//
// Copyright © 2025 Stream.io Inc. All rights reserved.
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
}
