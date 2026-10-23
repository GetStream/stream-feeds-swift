//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for shadow block action
public final class ShadowBlockActionRequestPayload: Sendable, Codable, JSONEncodable {
    /// Reason for shadow blocking
    public let reason: String?

    public init(reason: String? = nil) {
        self.reason = reason
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(reason, forKey: .reason)
    }
}

extension ShadowBlockActionRequestPayload: Hashable {
    public static func == (lhs: ShadowBlockActionRequestPayload, rhs: ShadowBlockActionRequestPayload) -> Bool {
        lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(reason)
    }
}
