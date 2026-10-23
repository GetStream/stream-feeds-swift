//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a soft-deleted comment is restored.
public final class CommentRestoredEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var comment: CommentResponse
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feedVisibility: String?
    public var fid: String
    public var receivedAt: Date?
    /// The type of event: "feeds.comment.restored" in this case
    public var type: String = "feeds.comment.restored"
    public var user: UserResponseCommonFields?

    public init(
        comment: CommentResponse,
        createdAt: Date,
        custom: [String: RawJSON],
        feedVisibility: String? = nil,
        fid: String,
        receivedAt: Date? = nil,
        user: UserResponseCommonFields? = nil
    ) {
        self.comment = comment
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension CommentRestoredEvent: Hashable {
    public static func == (lhs: CommentRestoredEvent, rhs: CommentRestoredEvent) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
