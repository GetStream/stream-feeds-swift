import Foundation
import StreamCore

public final class GetOrCreateFeedRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activitySelectorOptions: [String: RawJSON]?
    public var commentLimit: Int?
    public var commentSort: String?
    public var data: FeedInput?
    public var externalRanking: [String: RawJSON]?
    public var filter: [String: RawJSON]?
    public var followerPagination: PagerRequest?
    public var followingPagination: PagerRequest?
    public var interestWeights: [String: Float]?
    public var limit: Int?
    public var memberPagination: PagerRequest?
    public var next: String?
    public var prev: String?
    public var view: String?
    public var watch: Bool?

    public init(activitySelectorOptions: [String: RawJSON]? = nil, commentLimit: Int? = nil, commentSort: String? = nil, data: FeedInput? = nil, externalRanking: [String: RawJSON]? = nil, filter: [String: RawJSON]? = nil, followerPagination: PagerRequest? = nil, followingPagination: PagerRequest? = nil, interestWeights: [String: Float]? = nil, limit: Int? = nil, memberPagination: PagerRequest? = nil, next: String? = nil, prev: String? = nil, view: String? = nil, watch: Bool? = nil) {
        self.activitySelectorOptions = activitySelectorOptions
        self.commentLimit = commentLimit
        self.commentSort = commentSort
        self.data = data
        self.externalRanking = externalRanking
        self.filter = filter
        self.followerPagination = followerPagination
        self.followingPagination = followingPagination
        self.interestWeights = interestWeights
        self.limit = limit
        self.memberPagination = memberPagination
        self.next = next
        self.prev = prev
        self.view = view
        self.watch = watch
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activitySelectorOptions = "activity_selector_options"
        case commentLimit = "comment_limit"
        case commentSort = "comment_sort"
        case data
        case externalRanking = "external_ranking"
        case filter
        case followerPagination = "follower_pagination"
        case followingPagination = "following_pagination"
        case interestWeights = "interest_weights"
        case limit
        case memberPagination = "member_pagination"
        case next
        case prev
        case view
        case watch
    }

    public static func == (lhs: GetOrCreateFeedRequest, rhs: GetOrCreateFeedRequest) -> Bool {
        lhs.activitySelectorOptions == rhs.activitySelectorOptions &&
            lhs.commentLimit == rhs.commentLimit &&
            lhs.commentSort == rhs.commentSort &&
            lhs.data == rhs.data &&
            lhs.externalRanking == rhs.externalRanking &&
            lhs.filter == rhs.filter &&
            lhs.followerPagination == rhs.followerPagination &&
            lhs.followingPagination == rhs.followingPagination &&
            lhs.interestWeights == rhs.interestWeights &&
            lhs.limit == rhs.limit &&
            lhs.memberPagination == rhs.memberPagination &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.view == rhs.view &&
            lhs.watch == rhs.watch
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activitySelectorOptions)
        hasher.combine(commentLimit)
        hasher.combine(commentSort)
        hasher.combine(data)
        hasher.combine(externalRanking)
        hasher.combine(filter)
        hasher.combine(followerPagination)
        hasher.combine(followingPagination)
        hasher.combine(interestWeights)
        hasher.combine(limit)
        hasher.combine(memberPagination)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(view)
        hasher.combine(watch)
    }
}
