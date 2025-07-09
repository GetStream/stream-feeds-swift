//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateUserPartialRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var id: String
    public var set: [String: RawJSON]?
    public var unset: [String]?

    public init(id: String, set: [String: RawJSON]? = nil, unset: [String]? = nil) {
        self.id = id
        self.set = set
        self.unset = unset
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case set
        case unset
    }

    public static func == (lhs: UpdateUserPartialRequest, rhs: UpdateUserPartialRequest) -> Bool {
        lhs.id == rhs.id &&
            lhs.set == rhs.set &&
            lhs.unset == rhs.unset
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(set)
        hasher.combine(unset)
    }
}
