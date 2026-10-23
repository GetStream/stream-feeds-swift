//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Deprecated: Use restore instead, which now also reverses a block or shadow block. Configuration for unblock action.
public final class UnblockActionRequestPayload: Sendable, Codable, JSONEncodable {
    /// Reason for the appeal decision
    public let decisionReason: String?

    public init(decisionReason: String? = nil) {
        self.decisionReason = decisionReason
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.decisionReason = try container.decodeIfPresent(String.self, forKey: .decisionReason)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(decisionReason, forKey: .decisionReason)
    }
}

extension UnblockActionRequestPayload: Hashable {
    public static func == (lhs: UnblockActionRequestPayload, rhs: UnblockActionRequestPayload) -> Bool {
        lhs.decisionReason == rhs.decisionReason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(decisionReason)
    }
}
