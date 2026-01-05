//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollOptionResponseData: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]
    public var id: String
    public var text: String

    public init(custom: [String: RawJSON], id: String, text: String) {
        self.custom = custom
        self.id = id
        self.text = text
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case id
        case text
    }

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
