//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetOrCreateFeedRequest: Sendable, Codable, JSONEncodable {
    public let data: FeedInput?
    /// Feature-gated; not available for all apps. Request-scoped list of actor/user IDs whose activities are filtered from this GetOrCreateFeed response only. Merged (union) into the viewing user's in-memory blocked authors for this request; never persisted to blocked_users. Max: 1000.
    public let discardActors: [String]?
    /// Options to skip specific enrichments to improve performance. Default is false (enrichments are included). Setting a field to true skips that enrichment.
    public let enrichmentOptions: EnrichmentOptions?
    public let externalRanking: [String: RawJSON]?
    public let filter: [String: RawJSON]?
    public let followersPagination: PagerRequest?
    public let followingPagination: PagerRequest?
    /// Options to control fetching reactions from friends (users you follow or have mutual follows with).
    public let friendReactionsOptions: FriendReactionsOptions?
    public let idAround: String?
    public let interestWeights: [String: Double]?
    public let limit: Int?
    public let memberPagination: PagerRequest?
    public let next: String?
    public let overwriteInterestWeights: Bool?
    public let prev: String?
    public let view: String?
    public let viewerLocation: Location?
    public let watch: Bool?

    public init(data: FeedInput? = nil, discardActors: [String]? = nil, enrichmentOptions: EnrichmentOptions? = nil, externalRanking: [String: RawJSON]? = nil, filter: [String: RawJSON]? = nil, followersPagination: PagerRequest? = nil, followingPagination: PagerRequest? = nil, friendReactionsOptions: FriendReactionsOptions? = nil, idAround: String? = nil, interestWeights: [String: Double]? = nil, limit: Int? = nil, memberPagination: PagerRequest? = nil, next: String? = nil, overwriteInterestWeights: Bool? = nil, prev: String? = nil, view: String? = nil, viewerLocation: Location? = nil, watch: Bool? = nil) {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.data = try container.decodeIfPresent(FeedInput.self, forKey: .data)
        self.discardActors = try container.decodeIfPresent([String].self, forKey: .discardActors)
        self.enrichmentOptions = try container.decodeIfPresent(EnrichmentOptions.self, forKey: .enrichmentOptions)
        self.externalRanking = try container.decodeIfPresent([String: RawJSON].self, forKey: .externalRanking)
        self.filter = try container.decodeIfPresent([String: RawJSON].self, forKey: .filter)
        self.followersPagination = try container.decodeIfPresent(PagerRequest.self, forKey: .followersPagination)
        self.followingPagination = try container.decodeIfPresent(PagerRequest.self, forKey: .followingPagination)
        self.friendReactionsOptions = try container.decodeIfPresent(FriendReactionsOptions.self, forKey: .friendReactionsOptions)
        self.idAround = try container.decodeIfPresent(String.self, forKey: .idAround)
        self.interestWeights = try container.decodeIfPresent([String: Double].self, forKey: .interestWeights)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.memberPagination = try container.decodeIfPresent(PagerRequest.self, forKey: .memberPagination)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.overwriteInterestWeights = try container.decodeIfPresent(Bool.self, forKey: .overwriteInterestWeights)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.view = try container.decodeIfPresent(String.self, forKey: .view)
        self.viewerLocation = try container.decodeIfPresent(Location.self, forKey: .viewerLocation)
        self.watch = try container.decodeIfPresent(Bool.self, forKey: .watch)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(discardActors, forKey: .discardActors)
        try container.encodeIfPresent(enrichmentOptions, forKey: .enrichmentOptions)
        try container.encodeIfPresent(externalRanking, forKey: .externalRanking)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(followersPagination, forKey: .followersPagination)
        try container.encodeIfPresent(followingPagination, forKey: .followingPagination)
        try container.encodeIfPresent(friendReactionsOptions, forKey: .friendReactionsOptions)
        try container.encodeIfPresent(idAround, forKey: .idAround)
        try container.encodeIfPresent(interestWeights, forKey: .interestWeights)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(memberPagination, forKey: .memberPagination)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(overwriteInterestWeights, forKey: .overwriteInterestWeights)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encodeIfPresent(view, forKey: .view)
        try container.encodeIfPresent(viewerLocation, forKey: .viewerLocation)
        try container.encodeIfPresent(watch, forKey: .watch)
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
