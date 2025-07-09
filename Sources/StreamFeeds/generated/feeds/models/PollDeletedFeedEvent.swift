//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollDeletedFeedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var poll: PollResponseData
    public var receivedAt: Date?
    public var type: String = "feeds.poll.deleted"

    public init(createdAt: Date, custom: [String: RawJSON], fid: String, poll: PollResponseData, receivedAt: Date? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.poll = poll
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case fid
        case poll
        case receivedAt = "received_at"
        case type
    }

    public static func == (lhs: PollDeletedFeedEvent, rhs: PollDeletedFeedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.poll == rhs.poll &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(poll)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
