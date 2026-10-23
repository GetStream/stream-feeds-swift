//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollOptionResponseData: @unchecked Sendable, Codable, JSONEncodable {
    public var custom: [String: RawJSON]
    public var id: String
    public var text: String
    public var textI18n: [String: String]?

    public init(
        custom: [String: RawJSON],
        id: String,
        text: String,
        textI18n: [String: String]? = nil
    ) {
        self.custom = custom
        self.id = id
        self.text = text
        self.textI18n = textI18n
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case id
        case text
        case textI18n = "text_i18n"
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
