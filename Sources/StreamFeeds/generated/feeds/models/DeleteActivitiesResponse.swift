//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivitiesResponse: Sendable, Codable, JSONEncodable {
    /// List of activity IDs that were successfully deleted
    public let deletedIds: [String]
    public let duration: String

    public init(deletedIds: [String], duration: String) {
        self.deletedIds = deletedIds
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.deletedIds = try container.decode([String].self, forKey: .deletedIds)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(deletedIds, forKey: .deletedIds)
        try container.encode(duration, forKey: .duration)
    }
}

extension DeleteActivitiesResponse: Hashable {
    public static func == (lhs: DeleteActivitiesResponse, rhs: DeleteActivitiesResponse) -> Bool {
        lhs.deletedIds == rhs.deletedIds &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(deletedIds)
        hasher.combine(duration)
    }
}
