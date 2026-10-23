//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdatePollOptionRequest: Sendable, Codable, JSONEncodable {
    /// Custom data for this object
    public let custom: [String: RawJSON]?
    /// Option ID
    public let id: String
    /// Option text
    public let text: String

    public init(custom: [String: RawJSON]? = nil, id: String, text: String) {
        self.custom = custom
        self.id = id
        self.text = text
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
    }
}

extension UpdatePollOptionRequest: Hashable {
    public static func == (lhs: UpdatePollOptionRequest, rhs: UpdatePollOptionRequest) -> Bool {
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
