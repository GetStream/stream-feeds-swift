//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation

struct EndpointConfig {
    let hostname: String
    let wsEndpoint: String
    var baseFeedsURL: String {
        "\(hostname)"
    }
}

extension EndpointConfig {
    static let localhost = EndpointConfig(
        hostname: "http://localhost:3030",
        wsEndpoint: "ws://localhost:8800/api/v2/connect"
    )
    
    static let staging = EndpointConfig(
        hostname: "https://chat-edge-frankfurt-ce1.stream-io-api.com",
        wsEndpoint: "wss://chat-edge-frankfurt-ce1.stream-io-api.com/api/v2/connect"
    )
    
    static let production = EndpointConfig(
        hostname: "https://feeds.stream-io-api.com",
        wsEndpoint: "wss://feeds.stream-io-api.com/api/v2/connect"
    )
}
