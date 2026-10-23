//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedsPreferencesResponse: Sendable, Codable, JSONEncodable {
    public let comment: String?
    public let commentMention: String?
    public let commentReaction: String?
    public let commentReply: String?
    public let customActivityTypes: [String: String]?
    public let follow: String?
    public let mention: String?
    public let reaction: String?

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.commentMention = try container.decodeIfPresent(String.self, forKey: .commentMention)
        self.commentReaction = try container.decodeIfPresent(String.self, forKey: .commentReaction)
        self.commentReply = try container.decodeIfPresent(String.self, forKey: .commentReply)
        self.customActivityTypes = try container.decodeIfPresent([String: String].self, forKey: .customActivityTypes)
        self.follow = try container.decodeIfPresent(String.self, forKey: .follow)
        self.mention = try container.decodeIfPresent(String.self, forKey: .mention)
        self.reaction = try container.decodeIfPresent(String.self, forKey: .reaction)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(commentMention, forKey: .commentMention)
        try container.encodeIfPresent(commentReaction, forKey: .commentReaction)
        try container.encodeIfPresent(commentReply, forKey: .commentReply)
        try container.encodeIfPresent(customActivityTypes, forKey: .customActivityTypes)
        try container.encodeIfPresent(follow, forKey: .follow)
        try container.encodeIfPresent(mention, forKey: .mention)
        try container.encodeIfPresent(reaction, forKey: .reaction)
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
