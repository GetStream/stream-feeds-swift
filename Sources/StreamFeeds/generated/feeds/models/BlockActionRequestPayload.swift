//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for block action
public final class BlockActionRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Reason for blocking
    public var reason: String?

    public init(reason: String? = nil) {
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case reason
    }
}

extension BlockActionRequestPayload: Hashable {
    public static func == (lhs: BlockActionRequestPayload, rhs: BlockActionRequestPayload) -> Bool {
        lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(reason)
    }
}
