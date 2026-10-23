//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for block action
public final class BlockActionRequestPayload: Sendable, Codable, JSONEncodable {
    /// Reason for blocking
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

extension BlockActionRequestPayload: Hashable {
    public static func == (lhs: BlockActionRequestPayload, rhs: BlockActionRequestPayload) -> Bool {
        lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(reason)
    }
}
