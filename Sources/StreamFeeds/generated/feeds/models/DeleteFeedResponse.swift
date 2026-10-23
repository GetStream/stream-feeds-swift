//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteFeedResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String
    /// The ID of the async task that will handle feed cleanup and hard deletion
    public var taskId: String

    public init(duration: String, taskId: String) {
        self.duration = duration
        self.taskId = taskId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case taskId = "task_id"
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
