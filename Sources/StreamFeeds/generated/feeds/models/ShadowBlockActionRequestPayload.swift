//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for shadow block action
public final class ShadowBlockActionRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Reason for shadow blocking
    public var reason: String?

    public init(reason: String? = nil) {
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case reason
    }
}

extension ShadowBlockActionRequestPayload: Hashable {
    public static func == (
        lhs: ShadowBlockActionRequestPayload,
        rhs: ShadowBlockActionRequestPayload
    ) -> Bool {
        lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(reason)
    }
}
