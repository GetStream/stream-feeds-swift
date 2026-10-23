//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OCRRuleAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let bounce = OCRRuleAction(rawValue: "bounce")
    public static let bounceFlag = OCRRuleAction(rawValue: "bounce_flag")
    public static let bounceRemove = OCRRuleAction(rawValue: "bounce_remove")
    public static let flag = OCRRuleAction(rawValue: "flag")
    public static let remove = OCRRuleAction(rawValue: "remove")
    public static let shadow = OCRRuleAction(rawValue: "shadow")
}

public final class OCRRule: Sendable, Codable, JSONEncodable {
    public let action: OCRRuleAction
    public let label: String

    public init(action: OCRRuleAction, label: String) {
        self.action = action
        self.label = label
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(OCRRuleAction.self, forKey: .action)
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
