//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivitiesResponse: Sendable, Decodable {
    /// List of activity IDs that were successfully deleted
    public let deletedIds: [String]

    public init(deletedIds: [String]) {
        self.deletedIds = deletedIds
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.deletedIds = try container.decode([String].self, forKey: .deletedIds)
    }
}

extension DeleteActivitiesResponse: Hashable {
    public static func == (lhs: DeleteActivitiesResponse, rhs: DeleteActivitiesResponse) -> Bool {
        lhs.deletedIds == rhs.deletedIds
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(deletedIds)
    }
}
