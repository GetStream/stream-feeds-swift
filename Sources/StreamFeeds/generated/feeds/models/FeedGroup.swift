//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedGroup: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var appPK: Int
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var defaultViewID: String
    public var defaultVisibility: String
    public var deletedAt: Date?
    public var iD: String
    public var lastFeedGetAt: Date?
    public var notification: NotificationConfig?
    public var stories: StoriesConfig?
    public var updatedAt: Date

    public init(appPK: Int, createdAt: Date, custom: [String: RawJSON], defaultViewID: String, defaultVisibility: String, deletedAt: Date? = nil, iD: String, lastFeedGetAt: Date? = nil, notification: NotificationConfig? = nil, stories: StoriesConfig? = nil, updatedAt: Date) {
        self.appPK = appPK
        self.createdAt = createdAt
        self.custom = custom
        self.defaultViewID = defaultViewID
        self.defaultVisibility = defaultVisibility
        self.deletedAt = deletedAt
        self.iD = iD
        self.lastFeedGetAt = lastFeedGetAt
        self.notification = notification
        self.stories = stories
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case appPK = "AppPK"
        case createdAt = "created_at"
        case custom = "Custom"
        case defaultViewID = "DefaultViewID"
        case defaultVisibility = "DefaultVisibility"
        case deletedAt = "DeletedAt"
        case iD = "ID"
        case lastFeedGetAt = "LastFeedGetAt"
        case notification = "Notification"
        case stories = "Stories"
        case updatedAt = "updated_at"
    }

    public static func == (lhs: FeedGroup, rhs: FeedGroup) -> Bool {
        lhs.appPK == rhs.appPK &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.defaultViewID == rhs.defaultViewID &&
            lhs.defaultVisibility == rhs.defaultVisibility &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.iD == rhs.iD &&
            lhs.lastFeedGetAt == rhs.lastFeedGetAt &&
            lhs.notification == rhs.notification &&
            lhs.stories == rhs.stories &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(appPK)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(defaultViewID)
        hasher.combine(defaultVisibility)
        hasher.combine(deletedAt)
        hasher.combine(iD)
        hasher.combine(lastFeedGetAt)
        hasher.combine(notification)
        hasher.combine(stories)
        hasher.combine(updatedAt)
    }
}
