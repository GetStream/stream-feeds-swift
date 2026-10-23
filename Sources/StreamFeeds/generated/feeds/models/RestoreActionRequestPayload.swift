//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for restore action. State-aware: reverses whichever of a delete, a block, or a shadow block currently applies to the content (including both a delete and a block/shadow block at once).
public final class RestoreActionRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Reason for the appeal decision
    public var decisionReason: String?

    public init(decisionReason: String? = nil) {
        self.decisionReason = decisionReason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case decisionReason = "decision_reason"
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
