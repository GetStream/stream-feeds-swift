//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
@preconcurrency import StreamCore

public final class FeedsClient: Sendable {
    public let apiKey: APIKey
    public let user: User
    public let token: UserToken

    public let attachmentsUploader: StreamAttachmentUploader
    
    public let moderation: Moderation
    
    static let endpointConfig: EndpointConfig = .localhost
    
    private let apiClient: DefaultAPI
    private let devicesClient: DevicesAPI
    private let apiTransport: DefaultAPITransport
    private let cdnClient: CDNClient
    
    nonisolated(unsafe) private var requestEncoder: RequestEncoder
    nonisolated(unsafe) private var connectionProvider: ConnectionProvider?
        
    let connectionRecoveryHandler = AllocatedUnfairLock<ConnectionRecoveryHandler?>(nil)
    let webSocketClient = AllocatedUnfairLock<WebSocketClient?>(nil)
    
    let eventsMiddleware = WSEventsMiddleware()
    let eventNotificationCenter: EventNotificationCenter
    
    let activitiesRepository: ActivitiesRepository
    let bookmarksRepository: BookmarksRepository
    let commentsRepository: CommentsRepository
    let devicesRepository: DevicesRepository
    let feedsRepository: FeedsRepository
    let pollsRepository: PollsRepository
    
    private let _userAuth = AllocatedUnfairLock<UserAuth?>(nil)
    private let feedsConfig: FeedsConfig
    
    public var userAuth: UserAuth? {
        _userAuth.value
    }
    
    let connectTask = AllocatedUnfairLock<Task<Void, Error>?>(nil)
    
    nonisolated(unsafe) private let eventSubject: PassthroughSubject<Event, Never> = .init()
    public var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject
            .eraseToAnyPublisher()
    }

    
    /// Initializes a new FeedsClient instance.
    ///
    /// - Parameters:
    ///   - apiKey: The API key for authentication with the Stream service
    ///   - user: The user associated with this client
    ///   - token: The authentication token for the user
    ///   - pushNotificationsConfig: Configuration for push notifications. Defaults to `.default`
    ///   - tokenProvider: Optional token provider for dynamic token refresh
    public init(
        apiKey: APIKey,
        user: User,
        token: UserToken,
        feedsConfig: FeedsConfig = .default,
        tokenProvider: UserTokenProvider? = nil
    ) {
        self.apiKey = apiKey
        self.user = user
        self.token = token
        self.feedsConfig = feedsConfig
        self.apiTransport = URLSessionTransport(
            urlSession: Self.makeURLSession(),
            xStreamClientHeader: SystemEnvironment.xStreamClientHeader,
            tokenProvider: tokenProvider
        )
        let basePath = Self.endpointConfig.baseFeedsURL
        let defaultParams = DefaultParams(
            apiKey: apiKey.apiKeyString,
            xStreamClientHeader: SystemEnvironment.xStreamClientHeader
        )
        self.apiClient = DefaultAPI(
            basePath: basePath,
            transport: apiTransport,
            middlewares: [defaultParams]
        )
        self.devicesClient = DevicesAPI(
            basePath: basePath,
            transport: apiTransport,
            middlewares: [defaultParams]
        )
        self.eventNotificationCenter = EventNotificationCenter()
        self.requestEncoder = DefaultRequestEncoder(
            baseURL: URL(string: basePath)!,
            apiKey: apiKey
        )
        self.cdnClient = feedsConfig.customCDNClient ?? StreamCDNClient(
            encoder: requestEncoder,
            decoder: DefaultRequestDecoder(),
            sessionConfiguration: .default
        )
        self.attachmentsUploader = StreamAttachmentUploader(cdnClient: cdnClient)
        
        activitiesRepository = ActivitiesRepository(apiClient: apiClient, attachmentUploader: attachmentsUploader)
        bookmarksRepository = BookmarksRepository(apiClient: apiClient)
        commentsRepository = CommentsRepository(apiClient: apiClient)
        devicesRepository = DevicesRepository(devicesClient: devicesClient)
        feedsRepository = FeedsRepository(apiClient: apiClient)
        pollsRepository = PollsRepository(apiClient: apiClient)
        
        self.moderation = Moderation(apiClient: apiClient)
        
        eventsMiddleware.add(subscriber: self)
        eventNotificationCenter.add(middlewares: [eventsMiddleware])
    }
    
    // MARK: - Connecting the User
    
    /// Establishes a connection to the Stream service.
    ///
    /// This method sets up authentication and initializes the WebSocket connection for real-time updates.
    /// It should be called before using any other client functionality.
    ///
    /// - Throws: `ClientError` if the connection fails or authentication is invalid
    public func connect() async throws {
        if user.type != .anonymous {
            let userAuth = UserAuth { [weak self] in
                self?.token.rawValue ?? ""
            } connectionId: { [weak self] in
                guard let self else {
                    throw ClientError.Unexpected()
                }
                return await self.loadConnectionId()
            }
            self._userAuth.withLock { $0 = userAuth }
            let connectionId = try await userAuth.connectionId()
            connectionProvider = ConnectionProvider(
                connectionId: connectionId,
                token: token
            )
            self.requestEncoder.connectionDetailsProviderDelegate = connectionProvider
            apiClient.middlewares.append(userAuth)
            devicesClient.middlewares.append(userAuth)
        } else {
            let anonymousAuth = AnonymousAuth(token: token.rawValue)
            apiClient.middlewares.append(anonymousAuth)
        }
        
        initialConnectIfRequired(apiKey: apiKey.apiKeyString)
        try await connectTask.value?.value
    }
    
    // MARK: - Feeds
    
    /// Creates a feed instance for the specified group and ID.
    ///
    /// This method creates a `Feed` object that represents a specific feed.
    /// The feed can be used to fetch activities, manage follows, and receive real-time updates.
    ///
    /// - Parameters:
    ///   - group: The feed group identifier (e.g., "user", "timeline", "notification")
    ///   - id: The specific feed identifier within the group
    /// - Returns: A `Feed` instance that can be used to interact with the specified feed
    ///
    /// - Example:
    ///   ```swift
    ///   let userFeed = client.feed(group: "user", id: "john")
    ///   let timelineFeed = client.feed(group: "timeline", id: "flat")
    ///   ```
    public func feed(group: String, id: String) -> Feed {
        feed(for: FeedId(group: group, id: id))
    }
    
    /// Creates a feed instance for the specified feed ID.
    ///
    /// This method creates a `Feed` object that represents a specific feed using a `FeedId`.
    /// The feed can be used to fetch activities, manage follows, and receive real-time updates.
    ///
    /// - Parameter fid: The feed identifier containing the group and ID
    /// - Returns: A `Feed` instance that can be used to interact with the specified feed
    ///
    /// - Example:
    ///   ```swift
    ///   let feedId = FeedId(groupId: "user", id: "john")
    ///   let userFeed = client.feed(for: feedId)
    ///   ```
    public func feed(for fid: FeedId) -> Feed {
        feed(for: FeedQuery(fid: fid))
    }
    
    /// Creates a feed instance based on the provided query.
    ///
    /// This method creates a `Feed` object using a `FeedQuery` that can include additional
    /// configuration such as activity filters, limits, and feed data for creation.
    ///
    /// - Parameter query: The feed query containing the feed identifier and optional configuration
    /// - Returns: A `Feed` instance that can be used to interact with the specified feed
    ///
    /// - Example:
    ///   ```swift
    ///   let query = FeedQuery(
    ///       fid: FeedId(groupId: "user", id: "john"),
    ///       activityLimit: 20,
    ///       data: FeedInput(name: "John's Feed")
    ///   )
    ///   let feed = client.feed(for: query)
    ///   ```
    public func feed(for query: FeedQuery) -> Feed {
        Feed(query: query, client: self)
    }
    
    // MARK: - Feed Lists
    
    /// Creates a feed list instance based on the provided query.
    ///
    /// This method creates a `FeedList` object that represents a collection of feeds matching the specified query.
    /// The feed list can be used to fetch multiple feeds, manage feed groups, and receive real-time updates
    /// for all feeds in the list.
    ///
    /// - Parameter query: The feeds query containing filtering and pagination parameters
    /// - Returns: A `FeedList` instance that can be used to interact with the collection of feeds
    public func feedList(for query: FeedsQuery) -> FeedList {
        FeedList(query: query, client: self)
    }
    
    /// Creates a follow list instance based on the provided query.
    ///
    /// This method creates a `FollowList` object that represents a collection of follow relationships
    /// matching the specified query. The follow list can be used to fetch followers, following relationships,
    /// and manage follow data with pagination support.
    ///
    /// - Parameter query: The follows query containing filtering, sorting, and pagination parameters
    /// - Returns: A `FollowList` instance that can be used to interact with the collection of follow relationships
    public func followList(for query: FollowsQuery) -> FollowList {
        FollowList(query: query, client: self)
    }
    
    // MARK: - Events
    
    /// Creates a typed event publisher for specific event types.
    ///
    /// This method allows you to subscribe to specific event types by filtering the main event stream.
    /// It's useful when you only want to handle certain types of events.
    ///
    /// - Parameter event: The specific event type to filter for
    /// - Returns: A publisher that emits only events of the specified type
    ///
    /// - Example:
    ///   ```swift
    ///   client.eventPublisher(for: ActivityAddedEvent.self)
    ///       .sink { activityEvent in
    ///           print("New activity: \(activityEvent.activity.id)")
    ///       }
    ///       .store(in: &cancellables)
    ///   ```
    public func eventPublisher<WSEvent: Event>(
        for event: WSEvent.Type
    ) -> AnyPublisher<WSEvent, Never> {
        eventSubject
            .compactMap { $0 as? WSEvent }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Activities
    
    /// Creates an activity instance for the specified activity ID and feed.
    ///
    /// This method creates an `Activity` object that represents a specific activity within a feed.
    /// The activity can be used to manage comments, reactions, and other activity-specific operations.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity
    ///   - fid: The feed identifier where the activity belongs
    /// - Returns: An `Activity` instance that can be used to interact with the specified activity
    ///
    /// - Example:
    ///   ```swift
    ///   let feedId = FeedId(groupId: "user", id: "john")
    ///   let activity = client.activity(for: "activity-123", in: feedId)
    ///   ```
    public func activity(for activityId: String, in fid: FeedId) -> Activity {
        Activity(id: activityId, fid: fid, client: self)
    }
    
    /// Adds a new activity to the specified feeds.
    ///
    /// - Parameter request: The request containing the activity data to add
    /// - Returns: A response containing the created activity
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addActivity(request: AddActivityRequest) async throws -> AddActivityResponse {
        try await apiClient.addActivity(addActivityRequest: request)
    }
    
    /// Upserts (inserts or updates) multiple activities.
    ///
    /// - Parameter request: The array of requests to upsert
    /// - Returns: An array of upserted activities
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func upsertActivities(_ activities: [ActivityRequest]) async throws -> [ActivityData] {
        try await activitiesRepository.upsertActivities(activities)
    }
    
    /// Deletes multiple activities from the specified feeds.
    ///
    /// - Parameter request: The request containing the activities to delete
    /// - Returns: A response confirming the deletion of activities
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func deleteActivities(request: DeleteActivitiesRequest) async throws -> DeleteActivitiesResponse {
        try await apiClient.deleteActivities(deleteActivitiesRequest: request)
    }
    
    // MARK: - Bookmark Lists
    
    /// Creates a bookmark list instance based on the provided query.
    ///
    /// This method creates a `BookmarkList` object that represents a collection of bookmarks
    /// matching the specified query. The bookmark list can be used to fetch user bookmarks,
    /// manage bookmark folders, and receive real-time updates for bookmark-related events.
    ///
    /// - Parameter query: The bookmarks query containing filtering, sorting, and pagination parameters
    /// - Returns: A `BookmarkList` instance that can be used to interact with the collection of bookmarks
    public func bookmarkList(for query: BookmarksQuery) -> BookmarkList {
        BookmarkList(query: query, client: self)
    }
    
    /// Creates a bookmark folder list instance based on the provided query.
    ///
    /// This method creates a `BookmarkFolderList` object that represents a collection of bookmark folders
    /// matching the specified query. The bookmark folder list can be used to fetch user bookmark folders,
    /// manage folder organization, and receive real-time updates for folder-related events.
    ///
    /// - Parameter query: The bookmark folders query containing filtering, sorting, and pagination parameters
    /// - Returns: A `BookmarkFolderList` instance that can be used to interact with the collection of bookmark folders
    public func bookmarkFolderList(for query: BookmarkFoldersQuery) -> BookmarkFolderList {
        BookmarkFolderList(query: query, client: self)
    }
    
    // MARK: - Comment Lists
    
    /// Creates a comment list instance based on the provided query.
    ///
    /// This method creates a `CommentList` object that represents a collection of comments
    /// matching the specified query. The comment list can be used to fetch comments,
    /// manage comment pagination, and receive real-time updates for comment-related events.
    ///
    /// - Parameter query: The comments query containing filtering, sorting, and pagination parameters
    /// - Returns: A `CommentList` instance that can be used to interact with the collection of comments
    public func commentList(for query: CommentsQuery) -> CommentList {
        CommentList(query: query, client: self)
    }
    
    // MARK: - Poll Vote Lists
    
    /// Creates a poll vote list instance based on the provided query.
    ///
    /// This method creates a `PollVoteList` object that represents a collection of poll votes
    /// matching the specified query. The poll vote list can be used to fetch poll votes,
    /// manage vote pagination, and receive real-time updates for vote-related events.
    ///
    /// - Parameter query: The poll votes query containing filtering, sorting, and pagination parameters
    /// - Returns: A `PollVoteList` instance that can be used to interact with the collection of poll votes
    public func pollVoteList(for query: PollVotesQuery) -> PollVoteList {
        PollVoteList(query: query, client: self)
    }
    
    /// Creates a member list instance based on the provided query.
    ///
    /// This method creates a `MemberList` object that represents a collection of feed members
    /// matching the specified query. The member list can be used to fetch feed members,
    /// manage member pagination, and receive real-time updates for member-related events.
    ///
    /// - Parameter query: The members query containing filtering, sorting, and pagination parameters
    /// - Returns: A `MemberList` instance that can be used to interact with the collection of feed members
    public func memberList(for query: MembersQuery) -> MemberList {
        MemberList(query: query, client: self)
    }
    
    /// Creates a poll list instance based on the provided query.
    ///
    /// This method creates a `PollList` object that represents a collection of polls
    /// matching the specified query. The poll list can be used to fetch polls,
    /// manage poll pagination, and receive real-time updates for poll-related events.
    ///
    /// - Parameter query: The polls query containing filtering, sorting, and pagination parameters
    /// - Returns: A `PollList` instance that can be used to interact with the collection of polls
    public func pollList(for query: PollsQuery) -> PollList {
        PollList(query: query, client: self)
    }
    
    // MARK: - Devices
    
    /// Queries all devices associated with the current user.
    ///
    /// - Returns: A response containing the list of devices
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func queryDevices() async throws -> ListDevicesResponse {
        try await devicesRepository.queryDevices()
    }
    
    /// Creates a new device for push notifications.
    ///
    /// - Parameter id: The unique identifier for the device
    /// - Throws: 
    ///   - `ClientError` if the device ID is empty
    ///   - `ClientError` if the push provider is invalid
    ///   - `APIError` if the network request fails or the server returns an error
    public func createDevice(id: String) async throws {
        try await devicesRepository.createDevice(
            id: id,
            pushConfig: feedsConfig.pushNotificationsConfig
        )
    }
    
    /// Deletes a device by its identifier.
    ///
    /// - Parameter deviceId: The unique identifier of the device to delete
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deleteDevice(deviceId: String) async throws {
        try await devicesRepository.deleteDevice(deviceId: deviceId)
    }
    
    // MARK: - Files
    
    /// Deletes a previously uploaded file from the CDN.
    ///
    /// This is typically used for videos, or other non-image attachments.
    /// The method makes an asynchronous request to the global file deletion endpoint.
    ///
    /// - Parameter url: The full CDN URL of the file to delete.
    /// - Throws: An error if the request fails or the file could not be deleted.
    public func deleteFile(url: String) async throws {
        _ = try await self.apiClient.deleteFile(url: url)
    }

    /// Deletes a previously uploaded image from the CDN.
    ///
    /// This is intended for removing images such as user-uploaded photos or thumbnails.
    /// The method makes an asynchronous request to the global image deletion endpoint.
    ///
    /// - Parameter url: The full CDN URL of the image to delete.
    /// - Throws: An error if the request fails or the image could not be deleted.
    public func deleteImage(url: String) async throws {
        _ = try await self.apiClient.deleteImage(url: url)
    }
}

extension FeedsClient: ConnectionStateDelegate {
    
    /// Called when the WebSocket connection state changes.
    ///
    /// - Parameters:
    ///   - client: The WebSocket client that experienced the state change
    ///   - state: The new connection state
    public func webSocketClient(
        _ client: WebSocketClient,
        didUpdateConnectionState state: WebSocketConnectionState
    ) {}
}

extension FeedsClient: WSEventsSubscriber {
    
    func onEvent(_ event: any Event) {
        eventSubject.send(event)
    }
}
