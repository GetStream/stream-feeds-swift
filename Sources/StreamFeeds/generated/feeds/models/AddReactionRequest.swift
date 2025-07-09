//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddReactionRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var type: String

    public init(custom: [String: RawJSON]? = nil, type: String) {
        self.custom = custom
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case type
    }

    public static func == (lhs: AddReactionRequest, rhs: AddReactionRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(type)
    }
}
