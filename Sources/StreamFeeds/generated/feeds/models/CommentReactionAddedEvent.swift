//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CommentReactionAddedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var comment: CommentResponse
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feedVisibility: String?
    public var fid: String
    public var reaction: FeedsReactionResponse
    public var receivedAt: Date?
    public var type: String = "feeds.comment.reaction.added"
    public var user: UserResponseCommonFields?

    public init(comment: CommentResponse, createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, reaction: FeedsReactionResponse, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.comment = comment
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.reaction = reaction
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case reaction
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: CommentReactionAddedEvent, rhs: CommentReactionAddedEvent) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.reaction == rhs.reaction &&
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
        hasher.combine(reaction)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
