//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for escalation action
public final class EscalatePayload: Sendable, Codable, JSONEncodable {
    /// Additional context for the reviewer
    public let notes: String?
    /// Priority of the escalation (low, medium, high)
    public let priority: String?
    /// Reason for the escalation (from configured escalation_reasons)
    public let reason: String?

    public init(notes: String? = nil, priority: String? = nil, reason: String? = nil) {
        self.notes = notes
        self.priority = priority
        self.reason = reason
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.priority = try container.decodeIfPresent(String.self, forKey: .priority)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(priority, forKey: .priority)
        try container.encodeIfPresent(reason, forKey: .reason)
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
