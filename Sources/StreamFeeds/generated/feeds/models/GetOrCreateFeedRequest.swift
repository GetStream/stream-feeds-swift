import Foundation
import StreamCore

public final class GetOrCreateFeedRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum string: String, Sendable, Codable, CaseIterable {
        case first
        case last
        case popular
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

    public enum FeedVisibility: String, Sendable, Codable, CaseIterable {
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

    public var commentLimit: Int?
    public var commentSort: String?
    public var custom: [String: RawJSON]?
    public var externalRanking: [String: RawJSON]?
    public var filter: [String: RawJSON]?
    public var followerPagination: PagerRequest?
    public var followingPagination: PagerRequest?
    public var limit: Int?
    public var memberPagination: PagerRequest?
    public var members: [FeedMemberPayload]?
    public var next: String?
    public var prev: String?
    public var view: String?
    public var visibility: FeedVisibility?
    public var watch: Bool?

    public init(commentLimit: Int? = nil, commentSort: String? = nil, custom: [String: RawJSON]? = nil, externalRanking: [String: RawJSON]? = nil, filter: [String: RawJSON]? = nil, followerPagination: PagerRequest? = nil, followingPagination: PagerRequest? = nil, limit: Int? = nil, memberPagination: PagerRequest? = nil, members: [FeedMemberPayload]? = nil, next: String? = nil, prev: String? = nil, view: String? = nil, visibility: FeedVisibility? = nil, watch: Bool? = nil) {
        self.commentLimit = commentLimit
        self.commentSort = commentSort
        self.custom = custom
        self.externalRanking = externalRanking
        self.filter = filter
        self.followerPagination = followerPagination
        self.followingPagination = followingPagination
        self.limit = limit
        self.memberPagination = memberPagination
        self.members = members
        self.next = next
        self.prev = prev
        self.view = view
        self.visibility = visibility
        self.watch = watch
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case commentLimit = "comment_limit"
        case commentSort = "comment_sort"
        case custom
        case externalRanking = "external_ranking"
        case filter
        case followerPagination = "follower_pagination"
        case followingPagination = "following_pagination"
        case limit
        case memberPagination = "member_pagination"
        case members
        case next
        case prev
        case view
        case visibility
        case watch
    }

    public static func == (lhs: GetOrCreateFeedRequest, rhs: GetOrCreateFeedRequest) -> Bool {
        lhs.commentLimit == rhs.commentLimit &&
            lhs.commentSort == rhs.commentSort &&
            lhs.custom == rhs.custom &&
            lhs.externalRanking == rhs.externalRanking &&
            lhs.filter == rhs.filter &&
            lhs.followerPagination == rhs.followerPagination &&
            lhs.followingPagination == rhs.followingPagination &&
            lhs.limit == rhs.limit &&
            lhs.memberPagination == rhs.memberPagination &&
            lhs.members == rhs.members &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.view == rhs.view &&
            lhs.visibility == rhs.visibility &&
            lhs.watch == rhs.watch
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(commentLimit)
        hasher.combine(commentSort)
        hasher.combine(custom)
        hasher.combine(externalRanking)
        hasher.combine(filter)
        hasher.combine(followerPagination)
        hasher.combine(followingPagination)
        hasher.combine(limit)
        hasher.combine(memberPagination)
        hasher.combine(members)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(view)
        hasher.combine(visibility)
        hasher.combine(watch)
    }
}
