//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivitiesRequest: Sendable, Encodable, JSONEncodable {
    /// Whether to permanently delete the activities
    public let hardDelete: Bool?
    /// List of activity IDs to delete
    public let ids: [String]

    public init(hardDelete: Bool? = nil, ids: [String]) {
        self.hardDelete = hardDelete
        self.ids = ids
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(hardDelete, forKey: .hardDelete)
        try container.encode(ids, forKey: .ids)
    }
}

extension DeleteActivitiesRequest: Hashable {
    public static func == (lhs: DeleteActivitiesRequest, rhs: DeleteActivitiesRequest) -> Bool {
        lhs.hardDelete == rhs.hardDelete &&
            lhs.ids == rhs.ids
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hardDelete)
        hasher.combine(ids)
    }
}
