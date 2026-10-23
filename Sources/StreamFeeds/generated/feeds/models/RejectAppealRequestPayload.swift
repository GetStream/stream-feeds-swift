//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for rejecting an appeal
public final class RejectAppealRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Reason for rejecting the appeal
    public var decisionReason: String

    public init(decisionReason: String) {
        self.decisionReason = decisionReason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case decisionReason = "decision_reason"
    }
}

extension RejectAppealRequestPayload: Hashable {
    public static func == (lhs: RejectAppealRequestPayload, rhs: RejectAppealRequestPayload) -> Bool {
        lhs.decisionReason == rhs.decisionReason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(decisionReason)
    }
}
