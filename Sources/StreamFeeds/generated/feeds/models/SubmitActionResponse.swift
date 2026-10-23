//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SubmitActionResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var appealItem: AppealItemResponse?
    /// Present when the appeal was accepted but the entity could not be restored automatically. The moderator should restore it manually.
    public var autoRestoreWarning: String?
    public var duration: String
    public var item: ReviewQueueItemResponse?

    public init(appealItem: AppealItemResponse? = nil, autoRestoreWarning: String? = nil, duration: String, item: ReviewQueueItemResponse? = nil) {
        self.appealItem = appealItem
        self.autoRestoreWarning = autoRestoreWarning
        self.duration = duration
        self.item = item
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case appealItem = "appeal_item"
        case autoRestoreWarning = "auto_restore_warning"
        case duration
        case item
    }
}

extension SubmitActionResponse: Hashable {
    public static func == (lhs: SubmitActionResponse, rhs: SubmitActionResponse) -> Bool {
        lhs.appealItem == rhs.appealItem &&
            lhs.autoRestoreWarning == rhs.autoRestoreWarning &&
            lhs.duration == rhs.duration &&
            lhs.item == rhs.item
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(appealItem)
        hasher.combine(autoRestoreWarning)
        hasher.combine(duration)
        hasher.combine(item)
    }
}
