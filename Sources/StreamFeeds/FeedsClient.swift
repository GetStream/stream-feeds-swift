//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
@preconcurrency import StreamCore

//NOTE: change this to IP address to test push, for example: 192.168.0.227.
public let host = "localhost"

public final class FeedsClient: Sendable {
    // TODO: Update Core
    nonisolated(unsafe) public let apiKey: APIKey
    public let user: User
    public let token: UserToken
    
    private let apiClient: DefaultAPI
    private let devicesClient: DevicesAPI
    private let apiTransport: DefaultAPITransport
    
    let xStreamClientHeader = "stream-feeds-swift-v0.0.1"
    
    let connectionRecoveryHandler = AllocatedUnfairLock<ConnectionRecoveryHandler?>(nil)
    let webSocketClient = AllocatedUnfairLock<WebSocketClient?>(nil)
    
    let eventsMiddleware = WSEventsMiddleware()
    let eventNotificationCenter: EventNotificationCenter
    
    let activitiesRepository: ActivitiesRepository
    let commentsRepository: CommentsRepository
    let feedsRepository: FeedsRepository
    let pollsRepository: PollsRepository
    
    private let _userAuth = AllocatedUnfairLock<UserAuth?>(nil)
    private let pushNotificationsConfig: PushNotificationsConfig
    
    public var userAuth: UserAuth? {
        _userAuth.value
    }
    
    let connectTask = AllocatedUnfairLock<Task<Void, Error>?>(nil)
    
    public init(
        apiKey: APIKey,
        user: User,
        token: UserToken,
        pushNotificationsConfig: PushNotificationsConfig = .default,
        tokenProvider: UserTokenProvider? = nil
    ) {
        self.apiKey = apiKey
        self.user = user
        self.token = token
        self.pushNotificationsConfig = pushNotificationsConfig
        self.apiTransport = URLSessionTransport(
            urlSession: Self.makeURLSession(),
            xStreamClientHeader: xStreamClientHeader,
            tokenProvider: tokenProvider
        )
        let basePath = "http://\(host):3030"
        let defaultParams = DefaultParams(apiKey: apiKey.apiKeyString, xStreamClientHeader: xStreamClientHeader)
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
        eventNotificationCenter.add(middlewares: [eventsMiddleware])
        
        activitiesRepository = ActivitiesRepository(apiClient: apiClient)
        commentsRepository = CommentsRepository(apiClient: apiClient)
        feedsRepository = FeedsRepository(apiClient: apiClient)
        pollsRepository = PollsRepository(apiClient: apiClient)
    }
    
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
            apiClient.middlewares.append(userAuth)
            devicesClient.middlewares.append(userAuth)
        } else {
            let anonymousAuth = AnonymousAuth(token: token.rawValue)
            apiClient.middlewares.append(anonymousAuth)
        }
        
        initialConnectIfRequired(apiKey: apiKey.apiKeyString)
        try await connectTask.value?.value
    }
    
    // MARK: - Activities
    
    @discardableResult
    public func addActivity(request: AddActivityRequest) async throws -> AddActivityResponse {
        try await apiClient.addActivity(addActivityRequest: request)
    }
    
    @discardableResult
    public func upsertActivities(request: UpsertActivitiesRequest) async throws -> UpsertActivitiesResponse {
        try await apiClient.upsertActivities(upsertActivitiesRequest: request)
    }
    
    @discardableResult
    public func removeActivities(request: DeleteActivitiesRequest) async throws -> DeleteActivitiesResponse {
        try await apiClient.removeActivities(deleteActivitiesRequest: request)
    }
    
    // MARK: - Follows
    
    public func queryFollows(request: QueryFollowsRequest) async throws -> QueryFollowsResponse {
        try await apiClient.queryFollows(queryFollowsRequest: request)
    }
    
    // MARK: - Devices
    
    @discardableResult
    public func createDevice(id: String) async throws -> ModelResponse {
        guard !id.isEmpty else {
            throw ClientError("Device id must not be empty when trying to set device.")
        }
        guard let provider = CreateDeviceRequest.PushProvider(
            rawValue: pushNotificationsConfig.pushProviderInfo.pushProvider.rawValue
        ) else {
            throw ClientError.Unexpected("Invalid push provider value")
        }
        let request = CreateDeviceRequest(
            id: id,
            pushProvider: provider,
            pushProviderName: pushNotificationsConfig.pushProviderInfo.name,
            voipToken: nil
        )
        return try await devicesClient.createDevice(createDeviceRequest: request)
    }
    
    public func listDevices() async throws -> ListDevicesResponse {
        try await devicesClient.listDevices()
    }
    
    @discardableResult
    public func deleteDevice(deviceId: String) async throws -> ModelResponse {
        try await devicesClient.deleteDevice(id: deviceId)
    }
}

extension FeedsClient: ConnectionStateDelegate {
    
    public func webSocketClient(
        _ client: WebSocketClient,
        didUpdateConnectionState state: WebSocketConnectionState
    ) {}
}
