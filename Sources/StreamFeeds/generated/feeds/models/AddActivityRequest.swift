//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddActivityRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    
    public enum AddActivityRequestRestrictReplies: String, Sendable, Codable, CaseIterable {
        case everyone = "everyone"
        case nobody = "nobody"
        case peopleIFollow = "people_i_follow"
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
    
    public enum AddActivityRequestVisibility: String, Sendable, Codable, CaseIterable {
        case `private` = "private"
        case `public` = "public"
        case tag = "tag"
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
    public var attachments: [Attachment]?
    public var collectionRefs: [String]?
    public var createNotificationActivity: Bool?
    public var custom: [String: RawJSON]?
    public var expiresAt: String?
    public var feeds: [String]
    public var filterTags: [String]?
    public var id: String?
    public var interestTags: [String]?
    public var location: ActivityLocation?
    public var mentionedUserIds: [String]?
    public var parentId: String?
    public var pollId: String?
    public var restrictReplies: AddActivityRequestRestrictReplies?
    public var searchData: [String: RawJSON]?
    public var skipEnrichUrl: Bool?
    public var skipPush: Bool?
    public var text: String?
    public var type: String
    public var visibility: AddActivityRequestVisibility?
    public var visibilityTag: String?
    
    public init(attachments: [Attachment]? = nil, collectionRefs: [String]? = nil, createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, expiresAt: String? = nil, feeds: [String], filterTags: [String]? = nil, id: String? = nil, interestTags: [String]? = nil, location: ActivityLocation? = nil, mentionedUserIds: [String]? = nil, parentId: String? = nil, pollId: String? = nil, restrictReplies: AddActivityRequestRestrictReplies? = nil, searchData: [String: RawJSON]? = nil, skipEnrichUrl: Bool? = nil, skipPush: Bool? = nil, text: String? = nil, type: String, visibility: AddActivityRequestVisibility? = nil, visibilityTag: String? = nil) {
        self.attachments = attachments
        self.collectionRefs = collectionRefs
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.expiresAt = expiresAt
        self.feeds = feeds
        self.filterTags = filterTags
        self.id = id
        self.interestTags = interestTags
        self.location = location
        self.mentionedUserIds = mentionedUserIds
        self.parentId = parentId
        self.pollId = pollId
        self.restrictReplies = restrictReplies
        self.searchData = searchData
        self.skipEnrichUrl = skipEnrichUrl
        self.skipPush = skipPush
        self.text = text
        self.type = type
        self.visibility = visibility
        self.visibilityTag = visibilityTag
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case collectionRefs = "collection_refs"
        case createNotificationActivity = "create_notification_activity"
        case custom
        case expiresAt = "expires_at"
        case feeds
        case filterTags = "filter_tags"
        case id
        case interestTags = "interest_tags"
        case location
        case mentionedUserIds = "mentioned_user_ids"
        case parentId = "parent_id"
        case pollId = "poll_id"
        case restrictReplies = "restrict_replies"
        case searchData = "search_data"
        case skipEnrichUrl = "skip_enrich_url"
        case skipPush = "skip_push"
        case text
        case type
        case visibility
        case visibilityTag = "visibility_tag"
    }
    
    public static func == (lhs: AddActivityRequest, rhs: AddActivityRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
        lhs.collectionRefs == rhs.collectionRefs &&
        lhs.createNotificationActivity == rhs.createNotificationActivity &&
        lhs.custom == rhs.custom &&
        lhs.expiresAt == rhs.expiresAt &&
        lhs.feeds == rhs.feeds &&
        lhs.filterTags == rhs.filterTags &&
        lhs.id == rhs.id &&
        lhs.interestTags == rhs.interestTags &&
        lhs.location == rhs.location &&
        lhs.mentionedUserIds == rhs.mentionedUserIds &&
        lhs.parentId == rhs.parentId &&
        lhs.pollId == rhs.pollId &&
        lhs.restrictReplies == rhs.restrictReplies &&
        lhs.searchData == rhs.searchData &&
        lhs.skipEnrichUrl == rhs.skipEnrichUrl &&
        lhs.skipPush == rhs.skipPush &&
        lhs.text == rhs.text &&
        lhs.type == rhs.type &&
        lhs.visibility == rhs.visibility &&
        lhs.visibilityTag == rhs.visibilityTag
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(collectionRefs)
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(expiresAt)
        hasher.combine(feeds)
        hasher.combine(filterTags)
        hasher.combine(id)
        hasher.combine(interestTags)
        hasher.combine(location)
        hasher.combine(mentionedUserIds)
        hasher.combine(parentId)
        hasher.combine(pollId)
        hasher.combine(restrictReplies)
        hasher.combine(searchData)
        hasher.combine(skipEnrichUrl)
        hasher.combine(skipPush)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(visibility)
        hasher.combine(visibilityTag)
    }
}
