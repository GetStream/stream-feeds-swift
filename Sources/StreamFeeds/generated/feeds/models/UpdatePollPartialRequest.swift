//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdatePollPartialRequest: Sendable, Encodable, JSONEncodable {
    /// Sets new field values
    public let set: [String: RawJSON]?
    /// Array of field names to unset
    public let unset: [String]?

    public init(set: [String: RawJSON]? = nil, unset: [String]? = nil) {
        self.set = set
        self.unset = unset
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(set, forKey: .set)
        try container.encodeIfPresent(unset, forKey: .unset)
    }
}

extension UpdatePollPartialRequest: Hashable {
    public static func == (lhs: UpdatePollPartialRequest, rhs: UpdatePollPartialRequest) -> Bool {
        lhs.set == rhs.set &&
            lhs.unset == rhs.unset
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(set)
        hasher.combine(unset)
    }
}
