//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedsPreferences: @unchecked Sendable, Codable, JSONEncodable {
    public enum FeedsPreferencesComment: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum FeedsPreferencesCommentMention: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum FeedsPreferencesCommentReaction: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum FeedsPreferencesCommentReply: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum FeedsPreferencesFollow: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum FeedsPreferencesMention: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum FeedsPreferencesReaction: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// Push notification preference for comments on user's activities. One of: all, none
    public var comment: FeedsPreferencesComment?
    /// Push notification preference for reactions on comments. One of: all, none
    public var commentReaction: FeedsPreferencesCommentReaction?
    /// Push notification preferences for custom activity types. Map of activity type to preference (all or none)
    public var customActivityTypes: [String: String]?
    /// Push notification preference for new followers. One of: all, none
    public var follow: FeedsPreferencesFollow?
    /// Push notification preference for mentions in activities. One of: all, none
    public var mention: FeedsPreferencesMention?
    /// Push notification preference for reactions on user's activities or comments. One of: all, none
    public var reaction: FeedsPreferencesReaction?

    public init(comment: FeedsPreferencesComment? = nil, commentReaction: FeedsPreferencesCommentReaction? = nil, customActivityTypes: [String: String]? = nil, follow: FeedsPreferencesFollow? = nil, mention: FeedsPreferencesMention? = nil, reaction: FeedsPreferencesReaction? = nil) {
        self.comment = comment
        self.commentReaction = commentReaction
        self.customActivityTypes = customActivityTypes
        self.follow = follow
        self.mention = mention
        self.reaction = reaction
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case commentReaction = "comment_reaction"
        case customActivityTypes = "custom_activity_types"
        case follow
        case mention
        case reaction
    }
}

extension FeedsPreferences: Hashable {
    public static func == (lhs: FeedsPreferences, rhs: FeedsPreferences) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.commentReaction == rhs.commentReaction &&
            lhs.customActivityTypes == rhs.customActivityTypes &&
            lhs.follow == rhs.follow &&
            lhs.mention == rhs.mention &&
            lhs.reaction == rhs.reaction
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(commentReaction)
        hasher.combine(customActivityTypes)
        hasher.combine(follow)
        hasher.combine(mention)
        hasher.combine(reaction)
    }
}
