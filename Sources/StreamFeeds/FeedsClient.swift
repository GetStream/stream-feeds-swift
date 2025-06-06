//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public class FeedsClient: WSEventsSubscriber {
    
    public let apiKey: APIKey
    public let user: User
    public let token: UserToken
    
    private let apiClient: DefaultAPI
    private let apiTransport: DefaultAPITransport
    
    private let xStreamClientHeader = "stream-feeds-swift-v0.0.1"
    
    private(set) var connectionRecoveryHandler: ConnectionRecoveryHandler?
    
    private let eventsMiddleware = WSEventsMiddleware()
    private let feedsRepository: FeedsRepository
    
    public var userAuth: UserAuth?
    
    private(set) lazy var eventNotificationCenter: EventNotificationCenter = {
        let center = EventNotificationCenter()
        eventsMiddleware.add(subscriber: self)
        var middlewares: [EventMiddleware] = [
            eventsMiddleware
        ]
        center.add(middlewares: middlewares)
        return center
    }()
    
    private var webSocketClient: WebSocketClient? {
        didSet {
            setupConnectionRecoveryHandler()
        }
    }
    
    private var connectTask: Task<Void, Error>?
    
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
        feedsRepository = FeedsRepository(apiClient: apiClient)
        if user.type != .anonymous {
            let userAuth = UserAuth { [weak self] in
                self?.token.rawValue ?? ""
            } connectionId: { [weak self] in
                guard let self else {
                    throw ClientError.Unexpected()
                }
                return await self.loadConnectionId()
            }
            self.userAuth = userAuth
            apiClient.middlewares.append(userAuth)
        } else {
            let anonymousAuth = AnonymousAuth(token: token.rawValue)
            apiClient.middlewares.append(anonymousAuth)
        }
        
        initialConnectIfRequired(apiKey: apiKey.apiKeyString)
    }
    
    public func feed(group: String, id: String) -> Feed {
        Feed(group: group, id: id, user: user, repository: feedsRepository, events: eventsMiddleware)
    }
    
    public func activity(id: String) -> Activity {
        let activity = Activity(id: id, apiClient: apiClient)
        eventsMiddleware.add(subscriber: activity)
        return activity
    }
    
    public func follow(source: String, target: String) async throws -> SingleFollowResponse {
        try await apiClient.follow(singleFollowRequest: .init(source: source, target: target))
    }
    
    public func getFollowSuggestions(feedGroupId: String, limit: Int?) async throws -> [FeedInfo] {
        let response = try await apiClient.getFollowSuggestions(feedGroupId: feedGroupId, limit: limit)
        return response.suggestions.map(FeedInfo.init(from:))
    }
    
    func onEvent(_ event: any Event) {}
    
    // MARK: - private
    
    /// When initializing we perform an automatic connection attempt.
    ///
    /// - Important: This behaviour is only enabled for non-test environments. This is to reduce the
    /// noise in logs and avoid unnecessary network operations with the backend.
    private func initialConnectIfRequired(apiKey: String) {
        guard connectTask == nil else {
            return
        }

        //TODO: check guest users support.
        connectTask = Task {
            do {
                try Task.checkCancellation()
                try await self.connectUser(isInitial: true)
            } catch {
                log.error(error)
            }
        }
    }
    
    private func connectUser(isInitial: Bool = false) async throws {
        if !isInitial && connectTask != nil {
            log.debug("Waiting for already running connect task")
            _ = await connectTask?.result
        }
        if case .connected(healthCheckInfo: _) = webSocketClient?.connectionState {
            return
        }
        if user.type == .anonymous {
            // Anonymous users can't connect to the WS.
            throw ClientError.MissingPermissions()
        }
        try await connectWebSocketClient()
    }
    
    private func connectWebSocketClient() async throws {
        let queryParams = [
            "api_key": apiKey.apiKeyString,
            "stream-auth-type": "jwt",
            "X-Stream-Client": xStreamClientHeader // TODO: fix this
        ]
        
        let v2 = "ws://localhost:8800/api/v2/connect"
        if let connectURL = try? URL(string: v2)?.appendingQueryItems(queryParams) {
            webSocketClient = makeWebSocketClient(url: connectURL, apiKey: apiKey)
            webSocketClient?.connect()
        } else {
            throw ClientError.Unknown()
        }
        var connected = false
        var timeout = false
        let control = DefaultTimer.schedule(timeInterval: 30, queue: .sdk) {
            timeout = true
        }
        log.debug("Listening for WS connection")
        webSocketClient?.onConnected = {
            control.cancel()
            connected = true
            log.debug("WS connected")
        }

        while (!connected && !timeout) {
            try await Task.sleep(nanoseconds: 100_000)
        }
        
        if timeout {
            log.debug("Timeout while waiting for WS connection opening")
            throw ClientError.NetworkError()
        }
    }
    
    private func makeWebSocketClient(
        url: URL,
        apiKey: APIKey
    ) -> WebSocketClient {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = false
        
        // Create a WebSocketClient.
        let webSocketClient = WebSocketClient(
            sessionConfiguration: config,
            eventDecoder: JsonEventDecoder(),
            eventNotificationCenter: eventNotificationCenter,
            webSocketClientType: .coordinator,
            connectURL: url
        )
        
        webSocketClient.connectionStateDelegate = self
        webSocketClient.onWSConnectionEstablished = { [weak self, weak webSocketClient] in
            guard let self = self, let webSocketClient else { return }

            let connectUserRequest = ConnectUserDetailsRequest(
                custom: self.user.customData,
                id: self.user.id,
                image: self.user.imageURL?.absoluteString,
                name: self.user.originalName
            )
            
            let authRequest = WSAuthMessageRequest(
                products: ["feeds"],
                token: self.token.rawValue,
                userDetails: connectUserRequest
            )

            webSocketClient.engine?.send(jsonMessage: authRequest)
        }
        
        return webSocketClient
    }
    
    private func setupConnectionRecoveryHandler() {
        guard let webSocketClient = webSocketClient else {
            return
        }
        
        let backgroundTaskSchedulerBuilder: BackgroundTaskScheduler = IOSBackgroundTaskScheduler()

        connectionRecoveryHandler = nil
        connectionRecoveryHandler = DefaultConnectionRecoveryHandler(
            webSocketClient: webSocketClient,
            eventNotificationCenter: eventNotificationCenter,
            backgroundTaskScheduler: backgroundTaskSchedulerBuilder,
            internetConnection: InternetConnection(monitor: InternetConnection.Monitor()),
            reconnectionStrategy: DefaultRetryStrategy(),
            reconnectionTimerType: DefaultTimer.self,
            keepConnectionAliveInBackground: true
        )
    }
    
    private func loadConnectionId() async -> String {
        if let connectionId = loadConnectionIdFromHealthcheck() {
            return connectionId
        }
        
        guard webSocketClient?.connectionState == .connecting
            || webSocketClient?.connectionState == .authenticating else {
            return ""
        }
        
        var timeout = false
        let control = DefaultTimer.schedule(timeInterval: 5, queue: .sdk) {
            timeout = true
        }
        log.debug("Waiting for connection id")

        while (loadConnectionIdFromHealthcheck() == nil && !timeout) {
            try? await Task.sleep(nanoseconds: 100_000)
        }
        
        control.cancel()
        
        if let connectionId = loadConnectionIdFromHealthcheck() {
            log.debug("Connection id available from the WS")
            return connectionId
        }
        
        return ""
    }
    
    private func loadConnectionIdFromHealthcheck() -> String? {
        if case let .connected(healthCheckInfo: healtCheckInfo) = webSocketClient?.connectionState {
            return healtCheckInfo.connectionId
        }
        return nil
    }
    
    internal static func makeURLSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let urlSession = URLSession(configuration: config)
        return urlSession
    }
}

extension FeedsClient: ConnectionStateDelegate {
    
    public func webSocketClient(
        _ client: WebSocketClient,
        didUpdateConnectionState state: WebSocketConnectionState
    ) {}
}
