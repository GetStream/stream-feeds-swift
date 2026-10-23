//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreatePollOptionRequest: Sendable, Codable, JSONEncodable {
    /// Custom data for this object
    public let custom: [String: RawJSON]?
    /// Option text
    public let text: String

    public init(custom: [String: RawJSON]? = nil, text: String) {
        self.custom = custom
        self.text = text
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.text = try container.decode(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(text, forKey: .text)
    }
}

extension CreatePollOptionRequest: Hashable {
    public static func == (lhs: CreatePollOptionRequest, rhs: CreatePollOptionRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.text == rhs.text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(text)
    }
}
