//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdatePollPartialRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Sets new field values
    public var set: [String: RawJSON]?
    /// Array of field names to unset
    public var unset: [String]?

    public init(set: [String: RawJSON]? = nil, unset: [String]? = nil) {
        self.set = set
        self.unset = unset
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case set
        case unset
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
