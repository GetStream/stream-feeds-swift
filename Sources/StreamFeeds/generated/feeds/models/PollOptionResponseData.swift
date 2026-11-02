//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollOptionResponseData: Sendable, Decodable {
    public let custom: [String: RawJSON]
    public let id: String
    public let text: String

    public init(custom: [String: RawJSON], id: String, text: String) {
        self.custom = custom
        self.id = id
        self.text = text
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
    }
}

extension PollOptionResponseData: Hashable {
    public static func == (lhs: PollOptionResponseData, rhs: PollOptionResponseData) -> Bool {
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
