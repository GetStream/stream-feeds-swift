//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Field: Sendable, Codable, JSONEncodable {
    public let short: Bool
    public let title: String
    public let value: String

    public init(short: Bool, title: String, value: String) {
        self.short = short
        self.title = title
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.short = try container.decode(Bool.self, forKey: .short)
        self.title = try container.decode(String.self, forKey: .title)
        self.value = try container.decode(String.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(short, forKey: .short)
        try container.encode(title, forKey: .title)
        try container.encode(value, forKey: .value)
    }
}

extension Field: Hashable {
    public static func == (lhs: Field, rhs: Field) -> Bool {
        lhs.short == rhs.short &&
            lhs.title == rhs.title &&
            lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(short)
        hasher.combine(title)
        hasher.combine(value)
    }
}
