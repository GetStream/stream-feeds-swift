//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIImageLabelDefinition: @unchecked Sendable, Codable, JSONEncodable {
    public var description: String
    public var group: String
    public var key: String
    public var label: String

    public init(description: String, group: String, key: String, label: String) {
        self.description = description
        self.group = group
        self.key = key
        self.label = label
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case description
        case group
        case key
        case label
    }
}

extension AIImageLabelDefinition: Hashable {
    public static func == (lhs: AIImageLabelDefinition, rhs: AIImageLabelDefinition) -> Bool {
        lhs.description == rhs.description &&
            lhs.group == rhs.group &&
            lhs.key == rhs.key &&
            lhs.label == rhs.label
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
        hasher.combine(group)
        hasher.combine(key)
        hasher.combine(label)
    }
}
