//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIImageLabelDefinition: Sendable, Codable, JSONEncodable {
    public let description: String
    public let group: String
    public let key: String
    public let label: String

    public init(description: String, group: String, key: String, label: String) {
        self.description = description
        self.group = group
        self.key = key
        self.label = label
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.description = try container.decode(String.self, forKey: .description)
        self.group = try container.decode(String.self, forKey: .group)
        self.key = try container.decode(String.self, forKey: .key)
        self.label = try container.decode(String.self, forKey: .label)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(description, forKey: .description)
        try container.encode(group, forKey: .group)
        try container.encode(key, forKey: .key)
        try container.encode(label, forKey: .label)
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
