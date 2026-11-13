//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteFeedResponse: Sendable, Decodable {
    /// The ID of the async task that will handle feed cleanup and hard deletion
    public let taskId: String

    public init(taskId: String) {
        self.taskId = taskId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.taskId = try container.decode(String.self, forKey: .taskId)
    }
}

extension DeleteFeedResponse: Hashable {
    public static func == (lhs: DeleteFeedResponse, rhs: DeleteFeedResponse) -> Bool {
        lhs.taskId == rhs.taskId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(taskId)
    }
}
