//
//  FeedsClient.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 5.5.25.
//

import Foundation
import StreamCore

public class FeedsClient {
    
    public let apiKey: APIKey
    public let user: User
    public let token: UserToken
    
    private(set) var connectionRecoveryHandler: ConnectionRecoveryHandler?
    
    private(set) lazy var eventNotificationCenter: EventNotificationCenter = {
        //TODO: handle this.
        let center = EventNotificationCenter()
//        eventsMiddleware.add(subscriber: self)
//        var middlewares: [EventMiddleware] = [
//            eventsMiddleware
//        ]
//        center.add(middlewares: middlewares)
        return center
    }()
    
    private var webSocketClient: WebSocketClient? {
        didSet {
            setupConnectionRecoveryHandler()
        }
    }
    
    //TODO: token provider and other stuff.
    public init(apiKey: APIKey, user: User, token: UserToken) {
        self.apiKey = apiKey
        self.user = user
        self.token = token
    }
    
    public func connect() async throws {
        let queryParams = [
            "api_key": apiKey.apiKeyString,
            "stream-auth-type": "jwt",
            "X-Stream-Client": "stream-feeds-swift-v0.0.1" // TODO: fix this
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
    
    // MARK: - private
    
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
}

extension FeedsClient: ConnectionStateDelegate {
    
    public func webSocketClient(
        _ client: WebSocketClient,
        didUpdateConnectionState state: WebSocketConnectionState
    ) {
        print("======= \(state)")
    }
}
