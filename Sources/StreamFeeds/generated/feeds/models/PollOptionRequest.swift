//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollOptionRequest: Sendable, Codable, JSONEncodable {
    public let custom: [String: RawJSON]?
    public let id: String
    public let text: String?

    public init(custom: [String: RawJSON]? = nil, id: String, text: String? = nil) {
        self.custom = custom
        self.id = id
        self.text = text
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(text, forKey: .text)
    }
}

extension PollOptionRequest: Hashable {
    public static func == (lhs: PollOptionRequest, rhs: PollOptionRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.text == rhs.text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(text)
    }
}
