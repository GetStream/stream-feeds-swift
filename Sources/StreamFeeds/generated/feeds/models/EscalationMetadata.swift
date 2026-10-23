//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EscalationMetadata: Sendable, Codable, JSONEncodable {
    public let notes: String?
    public let priority: String?
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

extension EscalationMetadata: Hashable {
    public static func == (lhs: EscalationMetadata, rhs: EscalationMetadata) -> Bool {
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
