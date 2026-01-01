//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollOptionInput: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var text: String?

    public init(custom: [String: RawJSON]? = nil, text: String? = nil) {
        self.custom = custom
        self.text = text
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case text
    }

    public static func == (lhs: PollOptionInput, rhs: PollOptionInput) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.text == rhs.text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(text)
    }
}
