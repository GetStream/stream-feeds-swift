//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentReactionRequest: Sendable, Encodable, JSONEncodable {
    /// Whether to create a notification activity for this reaction
    public let createNotificationActivity: Bool?
    /// Optional custom data to add to the reaction
    public let custom: [String: RawJSON]?
    /// Whether to enforce unique reactions per user (remove other reaction types from the user when adding this one)
    public let enforceUnique: Bool?
    public let skipPush: Bool?
    /// Optional list of feeds to create a reference (share) activity of the commented-on activity in. The reference activity's type mirrors the reaction type.
    public let targetFeeds: [String]?
    /// The type of reaction, eg upvote, like, ...
    public let type: String

    public init(createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, enforceUnique: Bool? = nil, skipPush: Bool? = nil, targetFeeds: [String]? = nil, type: String) {
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.enforceUnique = enforceUnique
        self.skipPush = skipPush
        self.targetFeeds = targetFeeds
        self.type = type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(createNotificationActivity, forKey: .createNotificationActivity)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(enforceUnique, forKey: .enforceUnique)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
        try container.encodeIfPresent(targetFeeds, forKey: .targetFeeds)
        try container.encode(type, forKey: .type)
    }
}

extension AddCommentReactionRequest: Hashable {
    public static func == (lhs: AddCommentReactionRequest, rhs: AddCommentReactionRequest) -> Bool {
        lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.enforceUnique == rhs.enforceUnique &&
            lhs.skipPush == rhs.skipPush &&
            lhs.targetFeeds == rhs.targetFeeds &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(enforceUnique)
        hasher.combine(skipPush)
        hasher.combine(targetFeeds)
        hasher.combine(type)
    }
}
