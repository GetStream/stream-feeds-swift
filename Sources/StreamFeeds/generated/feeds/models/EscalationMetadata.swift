//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EscalationMetadata: @unchecked Sendable, Codable, JSONEncodable {
    public var notes: String?
    public var priority: String?
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
