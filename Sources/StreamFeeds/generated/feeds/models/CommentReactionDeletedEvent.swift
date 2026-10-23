//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a reaction is deleted from a comment.
public final class CommentReactionDeletedEvent: Sendable, Event, Decodable {
    public let comment: CommentResponse
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let feedVisibility: String?
    public let fid: String
    public let reaction: FeedsReactionResponse
    public let receivedAt: Date?
    /// The type of reaction that was removed
    public let type: String

    public init(comment: CommentResponse, createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, reaction: FeedsReactionResponse, receivedAt: Date? = nil, type: String = "feeds.comment.reaction.deleted") {
        self.comment = comment
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.reaction = reaction
        self.receivedAt = receivedAt
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(String.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
    }
}

extension CommentReactionDeletedEvent: Hashable {
    public static func == (lhs: CommentReactionDeletedEvent, rhs: CommentReactionDeletedEvent) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.reaction == rhs.reaction &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
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
    }
}
