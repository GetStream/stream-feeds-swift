//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
@preconcurrency import StreamCore

//NOTE: change this to IP address to test push, for example: 192.168.0.227.
public let host = "localhost"

public final class FeedsClient: Sendable {
    public let apiKey: APIKey
    public let user: User
    public let token: UserToken

    public let attachmentsUploader: StreamAttachmentUploader
    
    private let apiClient: DefaultAPI
    private let devicesClient: DevicesAPI
    private let apiTransport: DefaultAPITransport
    private let cdnClient: CDNClient
    
    nonisolated(unsafe) private var requestEncoder: RequestEncoder
    nonisolated(unsafe) private var connectionProvider: ConnectionProvider?
    
    let xStreamClientHeader = "stream-feeds-swift-v0.0.1"
    
    let connectionRecoveryHandler = AllocatedUnfairLock<ConnectionRecoveryHandler?>(nil)
    let webSocketClient = AllocatedUnfairLock<WebSocketClient?>(nil)
    
    let eventsMiddleware = WSEventsMiddleware()
    let eventNotificationCenter: EventNotificationCenter
    
    let activitiesRepository: ActivitiesRepository
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
            xStreamClientHeader: xStreamClientHeader,
            tokenProvider: tokenProvider
        )
        let basePath = "http://\(host):3030"
        let defaultParams = DefaultParams(
            apiKey: apiKey.apiKeyString,
            xStreamClientHeader: xStreamClientHeader
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
        
        activitiesRepository = ActivitiesRepository(apiClient: apiClient)
        commentsRepository = CommentsRepository(apiClient: apiClient)
        devicesRepository = DevicesRepository(devicesClient: devicesClient)
        feedsRepository = FeedsRepository(apiClient: apiClient)
        pollsRepository = PollsRepository(apiClient: apiClient)
        
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
        feed(for: FeedId(groupId: group, id: id))
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
        Feed(query: query, user: user, client: self)
    }
    
    /// Queries feeds based on the provided request parameters.
    ///
    /// - Parameter request: The query request containing filtering and pagination parameters
    /// - Returns: A response containing the queried feeds
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func queryFeeds(request: QueryFeedsRequest) async throws -> QueryFeedsResponse {
        try await apiClient.feedsQueryFeeds(queryFeedsRequest: request)
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
    /// - Parameter request: The request containing the activities to upsert
    /// - Returns: A response containing the upserted activities
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func upsertActivities(request: UpsertActivitiesRequest) async throws -> UpsertActivitiesResponse {
        try await apiClient.upsertActivities(upsertActivitiesRequest: request)
    }
    
    /// Removes multiple activities from the specified feeds.
    ///
    /// - Parameter request: The request containing the activities to remove
    /// - Returns: A response confirming the removal of activities
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func removeActivities(request: DeleteActivitiesRequest) async throws -> DeleteActivitiesResponse {
        try await apiClient.removeActivities(deleteActivitiesRequest: request)
    }
    
    // MARK: - Follows
    
    /// Queries follows based on the provided request parameters.
    ///
    /// - Parameter request: The query request containing filtering and pagination parameters
    /// - Returns: A response containing the queried follows
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func queryFollows(request: QueryFollowsRequest) async throws -> QueryFollowsResponse {
        try await apiClient.queryFollows(queryFollowsRequest: request)
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
