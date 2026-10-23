//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateUserPartialRequest: Sendable, Codable, JSONEncodable {
    /// User ID to update
    public let id: String
    public let set: [String: RawJSON]?
    public let unset: [String]?

    public init(id: String, set: [String: RawJSON]? = nil, unset: [String]? = nil) {
        self.id = id
        self.set = set
        self.unset = unset
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.set = try container.decodeIfPresent([String: RawJSON].self, forKey: .set)
        self.unset = try container.decodeIfPresent([String].self, forKey: .unset)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(set, forKey: .set)
        try container.encodeIfPresent(unset, forKey: .unset)
    }
}

extension UpdateUserPartialRequest: Hashable {
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
