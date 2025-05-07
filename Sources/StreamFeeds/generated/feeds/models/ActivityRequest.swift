import Foundation
import StreamCore

public final class ActivityRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum string: String, Sendable, Codable, CaseIterable {
        case followers
        case `private` = "private"
        case `public` = "public"
        case restricted = "restricted"
        case visible = "visible"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue)
            {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var attachments: [ActivityAttachment]?
    public var custom: [String: RawJSON]?
    public var expiresAt: String?
    public var fids: [String]
    public var filterTags: [String]?
    public var id: String?
    public var interestTags: [String]?
    public var location: ActivityLocation?
    public var mentionedUserIds: [String]?
    public var parentId: String?
    public var searchData: [String: RawJSON]?
    public var text: String?
    public var type: String
    public var userId: String?
    public var visibility: String?

    public init(attachments: [ActivityAttachment]? = nil, custom: [String: RawJSON]? = nil, expiresAt: String? = nil, fids: [String], filterTags: [String]? = nil, id: String? = nil, interestTags: [String]? = nil, location: ActivityLocation? = nil, mentionedUserIds: [String]? = nil, parentId: String? = nil, searchData: [String: RawJSON]? = nil, text: String? = nil, type: String, userId: String? = nil, visibility: String? = nil) {
        self.attachments = attachments
        self.custom = custom
        self.expiresAt = expiresAt
        self.fids = fids
        self.filterTags = filterTags
        self.id = id
        self.interestTags = interestTags
        self.location = location
        self.mentionedUserIds = mentionedUserIds
        self.parentId = parentId
        self.searchData = searchData
        self.text = text
        self.type = type
        self.userId = userId
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case custom
        case expiresAt = "expires_at"
        case fids
        case filterTags = "filter_tags"
        case id
        case interestTags = "interest_tags"
        case location
        case mentionedUserIds = "mentioned_user_ids"
        case parentId = "parent_id"
        case searchData = "search_data"
        case text
        case type
        case userId = "user_id"
        case visibility
    }

    public static func == (lhs: ActivityRequest, rhs: ActivityRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.custom == rhs.custom &&
            lhs.expiresAt == rhs.expiresAt &&
            lhs.fids == rhs.fids &&
            lhs.filterTags == rhs.filterTags &&
            lhs.id == rhs.id &&
            lhs.interestTags == rhs.interestTags &&
            lhs.location == rhs.location &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.parentId == rhs.parentId &&
            lhs.searchData == rhs.searchData &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.userId == rhs.userId &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(custom)
        hasher.combine(expiresAt)
        hasher.combine(fids)
        hasher.combine(filterTags)
        hasher.combine(id)
        hasher.combine(interestTags)
        hasher.combine(location)
        hasher.combine(mentionedUserIds)
        hasher.combine(parentId)
        hasher.combine(searchData)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(userId)
        hasher.combine(visibility)
    }
}
