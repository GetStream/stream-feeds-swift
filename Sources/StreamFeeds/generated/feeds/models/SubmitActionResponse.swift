//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SubmitActionResponse: Sendable, Codable, JSONEncodable {
    public let appealItem: AppealItemResponse?
    /// Present when the appeal was accepted but the entity could not be restored automatically. The moderator should restore it manually.
    public let autoRestoreWarning: String?
    public let duration: String
    public let item: ReviewQueueItemResponse?

    public init(appealItem: AppealItemResponse? = nil, autoRestoreWarning: String? = nil, duration: String, item: ReviewQueueItemResponse? = nil) {
        self.appealItem = appealItem
        self.autoRestoreWarning = autoRestoreWarning
        self.duration = duration
        self.item = item
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.appealItem = try container.decodeIfPresent(AppealItemResponse.self, forKey: .appealItem)
        self.autoRestoreWarning = try container.decodeIfPresent(String.self, forKey: .autoRestoreWarning)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.item = try container.decodeIfPresent(ReviewQueueItemResponse.self, forKey: .item)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(appealItem, forKey: .appealItem)
        try container.encodeIfPresent(autoRestoreWarning, forKey: .autoRestoreWarning)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(item, forKey: .item)
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
