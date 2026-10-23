//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollOptionInput: Sendable, Codable, JSONEncodable {
    public let custom: [String: RawJSON]?
    public let text: String?

    public init(custom: [String: RawJSON]? = nil, text: String? = nil) {
        self.custom = custom
        self.text = text
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(text, forKey: .text)
    }
}

extension PollOptionInput: Hashable {
    public static func == (lhs: PollOptionInput, rhs: PollOptionInput) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.text == rhs.text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(text)
    }
}
