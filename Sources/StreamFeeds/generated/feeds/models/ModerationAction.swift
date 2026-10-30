//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// What a moderation rule does when it matches.
public enum ModerationAction: String, Sendable, Codable, CaseIterable {
    case bounce
    case bounceFlag = "bounce_flag"
    case bounceRemove = "bounce_remove"
    case flag
    case remove
    case shadow
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = ModerationAction(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
