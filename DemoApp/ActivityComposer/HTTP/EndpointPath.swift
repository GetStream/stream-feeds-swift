//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

enum EndpointPath: Codable {
    
    case uploadAttachment(channelId: String, type: String)
    
    var value: String {
        switch self {
        case let .uploadAttachment(channelId, type): return "channels/\(channelId)/\(type)"
        }
    }
}
