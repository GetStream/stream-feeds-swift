//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

enum EndpointPath: Codable {
    
    case uploadAttachment(type: String)
    
    var value: String {
        switch self {
        case let .uploadAttachment(type): return "/api/v3/common/uploads/\(type)"
        }
    }
}
