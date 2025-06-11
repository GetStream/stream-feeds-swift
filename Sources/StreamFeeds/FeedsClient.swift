//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
@preconcurrency import StreamCore

public final class FeedsClient: Sendable {
    // TODO: Update Core
    nonisolated(unsafe) public let apiKey: APIKey
    public let user: User
    public let token: UserToken
    
    private let apiClient: DefaultAPI
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
    
    public var userAuth: UserAuth? {
        _userAuth.value
    }
    
    let connectTask = AllocatedUnfairLock<Task<Void, Error>?>(nil)
    
    //TODO: token provider, environment and other stuff.
    public init(apiKey: APIKey, user: User, token: UserToken) {
        self.apiKey = apiKey
        self.user = user
        self.token = token
        self.apiTransport = URLSessionTransport(
            urlSession: Self.makeURLSession(),
            xStreamClientHeader: xStreamClientHeader,
            tokenProvider: nil //TODO: fix this.
        )
        let defaultParams = DefaultParams(apiKey: apiKey.apiKeyString, xStreamClientHeader: xStreamClientHeader)
        self.apiClient = DefaultAPI(
            basePath: "http://localhost:3030",
            transport: apiTransport,
            middlewares: [defaultParams]
        )
        self.eventNotificationCenter = EventNotificationCenter()
        eventNotificationCenter.add(middlewares: [eventsMiddleware])
        
        activitiesRepository = ActivitiesRepository(apiClient: apiClient)
        commentsRepository = CommentsRepository(apiClient: apiClient)
        feedsRepository = FeedsRepository(apiClient: apiClient)
        pollsRepository = PollsRepository(apiClient: apiClient)
        
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
        } else {
            let anonymousAuth = AnonymousAuth(token: token.rawValue)
            apiClient.middlewares.append(anonymousAuth)
        }
        
        initialConnectIfRequired(apiKey: apiKey.apiKeyString)
    }
}

extension FeedsClient: ConnectionStateDelegate {
    
    public func webSocketClient(
        _ client: WebSocketClient,
        didUpdateConnectionState state: WebSocketConnectionState
    ) {}
}
