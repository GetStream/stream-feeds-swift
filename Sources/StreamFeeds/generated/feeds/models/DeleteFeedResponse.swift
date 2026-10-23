//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteFeedResponse: Sendable, Codable, JSONEncodable {
    public let duration: String
    /// The ID of the async task that will handle feed cleanup and hard deletion
    public let taskId: String

    public init(duration: String, taskId: String) {
        self.duration = duration
        self.taskId = taskId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.taskId = try container.decode(String.self, forKey: .taskId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(taskId, forKey: .taskId)
    }
}

extension DeleteFeedResponse: Hashable {
    public static func == (lhs: DeleteFeedResponse, rhs: DeleteFeedResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.taskId == rhs.taskId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(taskId)
    }
}
