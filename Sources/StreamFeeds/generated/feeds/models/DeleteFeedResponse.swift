//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteFeedResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var taskId: String

    public init(duration: String, taskId: String) {
        self.duration = duration
        self.taskId = taskId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case taskId = "task_id"
    }

    public static func == (lhs: DeleteFeedResponse, rhs: DeleteFeedResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.taskId == rhs.taskId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(taskId)
    }
}
