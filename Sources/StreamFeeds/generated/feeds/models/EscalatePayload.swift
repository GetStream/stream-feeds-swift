//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for escalation action
public final class EscalatePayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Additional context for the reviewer
    public var notes: String?
    /// Priority of the escalation (low, medium, high)
    public var priority: String?
    /// Reason for the escalation (from configured escalation_reasons)
    public var reason: String?

    public init(notes: String? = nil, priority: String? = nil, reason: String? = nil) {
        self.notes = notes
        self.priority = priority
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case notes
        case priority
        case reason
    }
}

extension EscalatePayload: Hashable {
    public static func == (lhs: EscalatePayload, rhs: EscalatePayload) -> Bool {
        lhs.notes == rhs.notes &&
            lhs.priority == rhs.priority &&
            lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(notes)
        hasher.combine(priority)
        hasher.combine(reason)
    }
}
