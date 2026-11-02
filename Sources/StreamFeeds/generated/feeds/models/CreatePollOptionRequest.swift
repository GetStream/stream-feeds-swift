//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreatePollOptionRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Custom data for this object
    public var custom: [String: RawJSON]?
    /// Option text
    public var text: String

    public init(custom: [String: RawJSON]? = nil, text: String) {
        self.custom = custom
        self.text = text
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case text
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
