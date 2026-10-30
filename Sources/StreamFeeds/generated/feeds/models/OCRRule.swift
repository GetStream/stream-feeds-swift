//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OCRRule: Sendable, Codable, JSONEncodable {
    /// What a moderation rule does when it matches.
    public let action: ModerationAction
    public let label: String

    public init(action: ModerationAction, label: String) {
        self.action = action
        self.label = label
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(ModerationAction.self, forKey: .action)
        self.label = try container.decode(String.self, forKey: .label)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(label, forKey: .label)
    }
}

extension OCRRule: Hashable {
    public static func == (lhs: OCRRule, rhs: OCRRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.label == rhs.label
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(label)
    }
}
