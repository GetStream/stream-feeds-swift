//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OCRRule: @unchecked Sendable, Codable, JSONEncodable {
    /// What a moderation rule does when it matches.
    public var action: ModerationAction
    public var label: String

    public init(action: ModerationAction, label: String) {
        self.action = action
        self.label = label
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case label
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
