//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdatePollOptionRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Custom data for this object
    public var custom: [String: RawJSON]?
    /// Option ID
    public var id: String
    /// Option text
    public var text: String

    public init(custom: [String: RawJSON]? = nil, id: String, text: String) {
        self.custom = custom
        self.id = id
        self.text = text
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case id
        case text
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
