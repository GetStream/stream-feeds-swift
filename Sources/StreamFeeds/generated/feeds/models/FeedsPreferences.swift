//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedsPreferencesComment: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FeedsPreferencesComment(rawValue: "all")
    public static let none = FeedsPreferencesComment(rawValue: "none")
}

public final class FeedsPreferencesCommentMention: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FeedsPreferencesCommentMention(rawValue: "all")
    public static let none = FeedsPreferencesCommentMention(rawValue: "none")
}

public final class FeedsPreferencesCommentReaction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FeedsPreferencesCommentReaction(rawValue: "all")
    public static let none = FeedsPreferencesCommentReaction(rawValue: "none")
}

public final class FeedsPreferencesCommentReply: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FeedsPreferencesCommentReply(rawValue: "all")
    public static let none = FeedsPreferencesCommentReply(rawValue: "none")
}

public final class FeedsPreferencesFollow: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FeedsPreferencesFollow(rawValue: "all")
    public static let none = FeedsPreferencesFollow(rawValue: "none")
}

public final class FeedsPreferencesMention: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FeedsPreferencesMention(rawValue: "all")
    public static let none = FeedsPreferencesMention(rawValue: "none")
}

public final class FeedsPreferencesReaction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = FeedsPreferencesReaction(rawValue: "all")
    public static let none = FeedsPreferencesReaction(rawValue: "none")
}

public final class FeedsPreferences: Sendable, Codable, JSONEncodable {
    /// Push notification preference for comments on user's activities. One of: all, none
    public let comment: FeedsPreferencesComment?
    /// Push notification preference for mentions in comments. One of: all, none
    public let commentMention: FeedsPreferencesCommentMention?
    /// Push notification preference for reactions on comments. One of: all, none
    public let commentReaction: FeedsPreferencesCommentReaction?
    /// Push notification preference for replies to comments. One of: all, none
    public let commentReply: FeedsPreferencesCommentReply?
    /// Push notification preferences for custom activity types. Map of activity type to preference (all or none)
    public let customActivityTypes: [String: String]?
    /// Push notification preference for new followers. One of: all, none
    public let follow: FeedsPreferencesFollow?
    /// Push notification preference for mentions in activities. One of: all, none
    public let mention: FeedsPreferencesMention?
    /// Push notification preference for reactions on user's activities or comments. One of: all, none
    public let reaction: FeedsPreferencesReaction?

    public init(comment: FeedsPreferencesComment? = nil, commentMention: FeedsPreferencesCommentMention? = nil, commentReaction: FeedsPreferencesCommentReaction? = nil, commentReply: FeedsPreferencesCommentReply? = nil, customActivityTypes: [String: String]? = nil, follow: FeedsPreferencesFollow? = nil, mention: FeedsPreferencesMention? = nil, reaction: FeedsPreferencesReaction? = nil) {
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
        self.comment = try container.decodeIfPresent(FeedsPreferencesComment.self, forKey: .comment)
        self.commentMention = try container.decodeIfPresent(FeedsPreferencesCommentMention.self, forKey: .commentMention)
        self.commentReaction = try container.decodeIfPresent(FeedsPreferencesCommentReaction.self, forKey: .commentReaction)
        self.commentReply = try container.decodeIfPresent(FeedsPreferencesCommentReply.self, forKey: .commentReply)
        self.customActivityTypes = try container.decodeIfPresent([String: String].self, forKey: .customActivityTypes)
        self.follow = try container.decodeIfPresent(FeedsPreferencesFollow.self, forKey: .follow)
        self.mention = try container.decodeIfPresent(FeedsPreferencesMention.self, forKey: .mention)
        self.reaction = try container.decodeIfPresent(FeedsPreferencesReaction.self, forKey: .reaction)
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

extension FeedsPreferences: Hashable {
    public static func == (lhs: FeedsPreferences, rhs: FeedsPreferences) -> Bool {
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
