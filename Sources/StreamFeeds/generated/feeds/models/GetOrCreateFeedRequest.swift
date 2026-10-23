//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetOrCreateFeedRequest: @unchecked Sendable, Codable, JSONEncodable {
    public var data: FeedInput?
    /// Feature-gated; not available for all apps. Request-scoped list of actor/user IDs whose activities are filtered from this GetOrCreateFeed response only. Merged (union) into the viewing user's in-memory blocked authors for this request; never persisted to blocked_users. Max: 1000.
    public var discardActors: [String]?
    /// Options to skip specific enrichments to improve performance. Default is false (enrichments are included). Setting a field to true skips that enrichment.
    public var enrichmentOptions: EnrichmentOptions?
    public var externalRanking: [String: RawJSON]?
    public var filter: [String: RawJSON]?
    public var followersPagination: PagerRequest?
    public var followingPagination: PagerRequest?
    /// Options to control fetching reactions from friends (users you follow or have mutual follows with).
    public var friendReactionsOptions: FriendReactionsOptions?
    public var idAround: String?
    public var interestWeights: [String: Float]?
    public var limit: Int?
    public var memberPagination: PagerRequest?
    public var next: String?
    public var overwriteInterestWeights: Bool?
    public var prev: String?
    public var view: String?
    public var viewerLocation: Location?
    public var watch: Bool?

    public init(data: FeedInput? = nil, discardActors: [String]? = nil, enrichmentOptions: EnrichmentOptions? = nil, externalRanking: [String: RawJSON]? = nil, filter: [String: RawJSON]? = nil, followersPagination: PagerRequest? = nil, followingPagination: PagerRequest? = nil, friendReactionsOptions: FriendReactionsOptions? = nil, idAround: String? = nil, interestWeights: [String: Float]? = nil, limit: Int? = nil, memberPagination: PagerRequest? = nil, next: String? = nil, overwriteInterestWeights: Bool? = nil, prev: String? = nil, view: String? = nil, viewerLocation: Location? = nil, watch: Bool? = nil) {
        self.data = data
        self.discardActors = discardActors
        self.enrichmentOptions = enrichmentOptions
        self.externalRanking = externalRanking
        self.filter = filter
        self.followersPagination = followersPagination
        self.followingPagination = followingPagination
        self.friendReactionsOptions = friendReactionsOptions
        self.idAround = idAround
        self.interestWeights = interestWeights
        self.limit = limit
        self.memberPagination = memberPagination
        self.next = next
        self.overwriteInterestWeights = overwriteInterestWeights
        self.prev = prev
        self.view = view
        self.viewerLocation = viewerLocation
        self.watch = watch
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case data
        case discardActors = "discard_actors"
        case enrichmentOptions = "enrichment_options"
        case externalRanking = "external_ranking"
        case filter
        case followersPagination = "followers_pagination"
        case followingPagination = "following_pagination"
        case friendReactionsOptions = "friend_reactions_options"
        case idAround = "id_around"
        case interestWeights = "interest_weights"
        case limit
        case memberPagination = "member_pagination"
        case next
        case overwriteInterestWeights = "overwrite_interest_weights"
        case prev
        case view
        case viewerLocation = "viewer_location"
        case watch
    }
}

extension GetOrCreateFeedRequest: Hashable {
    public static func == (lhs: GetOrCreateFeedRequest, rhs: GetOrCreateFeedRequest) -> Bool {
        lhs.data == rhs.data &&
            lhs.discardActors == rhs.discardActors &&
            lhs.enrichmentOptions == rhs.enrichmentOptions &&
            lhs.externalRanking == rhs.externalRanking &&
            lhs.filter == rhs.filter &&
            lhs.followersPagination == rhs.followersPagination &&
            lhs.followingPagination == rhs.followingPagination &&
            lhs.friendReactionsOptions == rhs.friendReactionsOptions &&
            lhs.idAround == rhs.idAround &&
            lhs.interestWeights == rhs.interestWeights &&
            lhs.limit == rhs.limit &&
            lhs.memberPagination == rhs.memberPagination &&
            lhs.next == rhs.next &&
            lhs.overwriteInterestWeights == rhs.overwriteInterestWeights &&
            lhs.prev == rhs.prev &&
            lhs.view == rhs.view &&
            lhs.viewerLocation == rhs.viewerLocation &&
            lhs.watch == rhs.watch
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
        hasher.combine(discardActors)
        hasher.combine(enrichmentOptions)
        hasher.combine(externalRanking)
        hasher.combine(filter)
        hasher.combine(followersPagination)
        hasher.combine(followingPagination)
        hasher.combine(friendReactionsOptions)
        hasher.combine(idAround)
        hasher.combine(interestWeights)
        hasher.combine(limit)
        hasher.combine(memberPagination)
        hasher.combine(next)
        hasher.combine(overwriteInterestWeights)
        hasher.combine(prev)
        hasher.combine(view)
        hasher.combine(viewerLocation)
        hasher.combine(watch)
    }
}
