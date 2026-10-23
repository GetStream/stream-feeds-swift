//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedsPreferencesResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var comment: String?
    public var commentMention: String?
    public var commentReaction: String?
    public var commentReply: String?
    public var customActivityTypes: [String: String]?
    public var follow: String?
    public var mention: String?
    public var reaction: String?

    public init(comment: String? = nil, commentMention: String? = nil, commentReaction: String? = nil, commentReply: String? = nil, customActivityTypes: [String: String]? = nil, follow: String? = nil, mention: String? = nil, reaction: String? = nil) {
        self.comment = comment
        self.commentMention = commentMention
        self.commentReaction = commentReaction
        self.commentReply = commentReply
        self.customActivityTypes = customActivityTypes
        self.follow = follow
        self.mention = mention
        self.reaction = reaction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case commentMention = "comment_mention"
        case commentReaction = "comment_reaction"
        case commentReply = "comment_reply"
        case customActivityTypes = "custom_activity_types"
        case follow
        case mention
        case reaction
    }
}

extension FeedsPreferencesResponse: Hashable {
    public static func == (lhs: FeedsPreferencesResponse, rhs: FeedsPreferencesResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.commentMention == rhs.commentMention &&
            lhs.commentReaction == rhs.commentReaction &&
            lhs.commentReply == rhs.commentReply &&
            lhs.customActivityTypes == rhs.customActivityTypes &&
            lhs.follow == rhs.follow &&
            lhs.mention == rhs.mention &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(commentMention)
        hasher.combine(commentReaction)
        hasher.combine(commentReply)
        hasher.combine(customActivityTypes)
        hasher.combine(follow)
        hasher.combine(mention)
        hasher.combine(reaction)
    }
}
