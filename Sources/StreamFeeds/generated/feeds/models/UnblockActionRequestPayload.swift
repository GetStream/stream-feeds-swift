//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Deprecated: Use restore instead, which now also reverses a block or shadow block. Configuration for unblock action.
public final class UnblockActionRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Reason for the appeal decision
    public var decisionReason: String?

    public init(decisionReason: String? = nil) {
        self.decisionReason = decisionReason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case decisionReason = "decision_reason"
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
