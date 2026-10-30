//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Action: Sendable, Codable, JSONEncodable {
    public let name: String
    public let style: String?
    public let text: String
    public let type: String
    public let value: String?

    public init(name: String, style: String? = nil, text: String, type: String, value: String? = nil) {
        self.name = name
        self.style = style
        self.text = text
        self.type = type
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.style = try container.decodeIfPresent(String.self, forKey: .style)
        self.text = try container.decode(String.self, forKey: .text)
        self.type = try container.decode(String.self, forKey: .type)
        self.value = try container.decodeIfPresent(String.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(style, forKey: .style)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(value, forKey: .value)
    }
}

extension Action: Hashable {
    public static func == (lhs: Action, rhs: Action) -> Bool {
        lhs.name == rhs.name &&
            lhs.style == rhs.style &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(style)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(value)
    }
}
