//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CommentReactionDeletedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var comment: CommentResponse
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var reaction: FeedsReactionResponse
    public var receivedAt: Date?
    public var type: String = "feeds.comment.reaction.deleted"

    public init(comment: CommentResponse, createdAt: Date, custom: [String: RawJSON], fid: String, reaction: FeedsReactionResponse, receivedAt: Date? = nil) {
        self.comment = comment
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.reaction = reaction
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case createdAt = "created_at"
        case custom
        case fid
        case reaction
        case receivedAt = "received_at"
        case type
    }

    public static func == (lhs: CommentReactionDeletedEvent, rhs: CommentReactionDeletedEvent) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.reaction == rhs.reaction &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(reaction)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
