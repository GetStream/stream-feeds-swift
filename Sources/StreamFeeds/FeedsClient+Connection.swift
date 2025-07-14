//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension FeedsClient {
    /// When initializing we perform an automatic connection attempt.
    ///
    /// - Important: This behaviour is only enabled for non-test environments. This is to reduce the
    /// noise in logs and avoid unnecessary network operations with the backend.
    func initialConnectIfRequired(apiKey: String) {
        guard connectTask.value == nil else {
            return
        }

        // TODO: check guest users support.
        connectTask.value = Task {
            do {
                try Task.checkCancellation()
                try await self.connectUser(isInitial: true)
            } catch {
                log.error(error)
                throw error
            }
        }
    }
    
    private func connectUser(isInitial: Bool = false) async throws {
        if !isInitial && connectTask.value != nil {
            log.debug("Waiting for already running connect task")
            _ = await connectTask.value?.result
        }
        if case .connected = webSocketClient.value?.connectionState {
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
            "X-Stream-Client": SystemEnvironment.xStreamClientHeader
        ]
        
        let webSocketClient: WebSocketClient
        if let connectURL = try? URL(string: Self.endpointConfig.wsEndpoint)?.appendingQueryItems(queryParams) {
            webSocketClient = makeWebSocketClient(url: connectURL, apiKey: apiKey)
            self.webSocketClient.value = webSocketClient
            setupConnectionRecoveryHandler()
            webSocketClient.connect()
        } else {
            throw ClientError.Unknown()
        }
        var connected = false
        var timeout = false
        let control = DefaultTimer.schedule(timeInterval: 30, queue: .sdk) {
            timeout = true
        }
        log.debug("Listening for WS connection")
        webSocketClient.onConnected = {
            control.cancel()
            connected = true
            log.debug("WS connected")
        }

        while !connected && !timeout {
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
            eventDecoder: JSONEventDecoder(),
            eventNotificationCenter: eventNotificationCenter,
            webSocketClientType: .coordinator,
            connectURL: url
        )
        
        webSocketClient.connectionStateDelegate = self
        webSocketClient.onWSConnectionEstablished = { [weak self, weak webSocketClient] in
            guard let self, let webSocketClient else { return }

            let connectUserRequest = ConnectUserDetailsRequest(
                custom: user.customData,
                id: user.id,
                image: user.imageURL?.absoluteString,
                name: user.originalName
            )
            
            let authRequest = WSAuthMessageRequest(
                products: ["feeds"],
                token: token.rawValue,
                userDetails: connectUserRequest
            )

            webSocketClient.engine?.send(jsonMessage: authRequest)
        }
        
        return webSocketClient
    }
    
    private func setupConnectionRecoveryHandler() {
        guard let webSocketClient = webSocketClient.value else {
            return
        }
        
        let backgroundTaskSchedulerBuilder: BackgroundTaskScheduler = IOSBackgroundTaskScheduler()

        connectionRecoveryHandler.value = DefaultConnectionRecoveryHandler(
            webSocketClient: webSocketClient,
            eventNotificationCenter: eventNotificationCenter,
            backgroundTaskScheduler: backgroundTaskSchedulerBuilder,
            internetConnection: InternetConnection(monitor: InternetConnection.Monitor()),
            reconnectionStrategy: DefaultRetryStrategy(),
            reconnectionTimerType: DefaultTimer.self,
            keepConnectionAliveInBackground: true
        )
    }
    
    func loadConnectionId() async -> String {
        if let connectionId = loadConnectionIdFromHealthcheck() {
            return connectionId
        }
        guard let connectionState = webSocketClient.value?.connectionState else { return "" }
        
        guard connectionState == .connecting
            || connectionState == .authenticating else {
            return ""
        }
        
        var timeout = false
        let control = DefaultTimer.schedule(timeInterval: 5, queue: .sdk) {
            timeout = true
        }
        log.debug("Waiting for connection id")

        while loadConnectionIdFromHealthcheck() == nil && !timeout {
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
        if case let .connected(healthCheckInfo: healtCheckInfo) = webSocketClient.value?.connectionState {
            return healtCheckInfo.connectionId
        }
        return nil
    }
    
    static func makeURLSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let urlSession = URLSession(configuration: config)
        return urlSession
    }
}
