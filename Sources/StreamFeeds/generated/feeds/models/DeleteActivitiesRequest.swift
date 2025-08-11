//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivitiesRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var hardDelete: Bool?
    public var ids: [String]

    public init(hardDelete: Bool? = nil, ids: [String]) {
        self.hardDelete = hardDelete
        self.ids = ids
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case hardDelete = "hard_delete"
        case ids
    }

    public static func == (lhs: DeleteActivitiesRequest, rhs: DeleteActivitiesRequest) -> Bool {
        lhs.hardDelete == rhs.hardDelete &&
            lhs.ids == rhs.ids
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hardDelete)
        hasher.combine(ids)
    }
}
