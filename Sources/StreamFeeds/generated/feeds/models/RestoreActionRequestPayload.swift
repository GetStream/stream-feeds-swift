//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for restore action. State-aware: reverses whichever of a delete, a block, or a shadow block currently applies to the content (including both a delete and a block/shadow block at once).
public final class RestoreActionRequestPayload: Sendable, Codable, JSONEncodable {
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

extension RestoreActionRequestPayload: Hashable {
    public static func == (lhs: RestoreActionRequestPayload, rhs: RestoreActionRequestPayload) -> Bool {
        lhs.decisionReason == rhs.decisionReason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(decisionReason)
    }
}
