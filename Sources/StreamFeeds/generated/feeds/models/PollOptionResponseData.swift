//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollOptionResponseData: Sendable, Codable, JSONEncodable {
    public let custom: [String: RawJSON]
    public let id: String
    public let text: String
    public let textI18n: [String: String]?

    public init(custom: [String: RawJSON], id: String, text: String, textI18n: [String: String]? = nil) {
        self.custom = custom
        self.id = id
        self.text = text
        self.textI18n = textI18n
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.textI18n = try container.decodeIfPresent([String: String].self, forKey: .textI18n)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(custom, forKey: .custom)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(textI18n, forKey: .textI18n)
    }
}

extension PollOptionResponseData: Hashable {
    public static func == (lhs: PollOptionResponseData, rhs: PollOptionResponseData) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.text == rhs.text &&
            lhs.textI18n == rhs.textI18n
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(text)
        hasher.combine(textI18n)
    }
}
