//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddActivityRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum AddActivityRequestVisibility: String, Sendable, Codable, CaseIterable {
        case `private`
        case `public`
        case tag
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
    public var searchData: [String: RawJSON]?
    public var text: String?
    public var type: String
    public var visibility: AddActivityRequestVisibility?
    public var visibilityTag: String?

    public init(attachments: [Attachment]? = nil, custom: [String: RawJSON]? = nil, expiresAt: String? = nil, feeds: [String], filterTags: [String]? = nil, id: String? = nil, interestTags: [String]? = nil, location: ActivityLocation? = nil, mentionedUserIds: [String]? = nil, parentId: String? = nil, pollId: String? = nil, searchData: [String: RawJSON]? = nil, text: String? = nil, type: String, visibility: AddActivityRequestVisibility? = nil, visibilityTag: String? = nil) {
        self.attachments = attachments
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
        self.searchData = searchData
        self.text = text
        self.type = type
        self.visibility = visibility
        self.visibilityTag = visibilityTag
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case custom
        case expiresAt = "expires_at"
        case feeds = "fids" //TODO: temp fix.
        case filterTags = "filter_tags"
        case id
        case interestTags = "interest_tags"
        case location
        case mentionedUserIds = "mentioned_user_ids"
        case parentId = "parent_id"
        case pollId = "poll_id"
        case searchData = "search_data"
        case text
        case type
        case visibility
        case visibilityTag = "visibility_tag"
    }

    public static func == (lhs: AddActivityRequest, rhs: AddActivityRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
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
            lhs.searchData == rhs.searchData &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.visibility == rhs.visibility &&
            lhs.visibilityTag == rhs.visibilityTag
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
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
        hasher.combine(searchData)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(visibility)
        hasher.combine(visibilityTag)
    }
}
