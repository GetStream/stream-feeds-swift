//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetOrCreateFeedRequest: Sendable, Codable, JSONEncodable {
    public let data: FeedInput?
    public let externalRanking: [String: RawJSON]?
    public let filter: [String: RawJSON]?
    public let followersPagination: PagerRequest?
    public let followingPagination: PagerRequest?
    public let interestWeights: [String: Double]?
    public let limit: Int?
    public let memberPagination: PagerRequest?
    public let next: String?
    public let prev: String?
    public let view: String?
    public let watch: Bool?

    public init(data: FeedInput? = nil, externalRanking: [String: RawJSON]? = nil, filter: [String: RawJSON]? = nil, followersPagination: PagerRequest? = nil, followingPagination: PagerRequest? = nil, interestWeights: [String: Double]? = nil, limit: Int? = nil, memberPagination: PagerRequest? = nil, next: String? = nil, prev: String? = nil, view: String? = nil, watch: Bool? = nil) {
        self.data = data
        self.externalRanking = externalRanking
        self.filter = filter
        self.followersPagination = followersPagination
        self.followingPagination = followingPagination
        self.interestWeights = interestWeights
        self.limit = limit
        self.memberPagination = memberPagination
        self.next = next
        self.prev = prev
        self.view = view
        self.watch = watch
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.data = try container.decodeIfPresent(FeedInput.self, forKey: .data)
        self.externalRanking = try container.decodeIfPresent([String: RawJSON].self, forKey: .externalRanking)
        self.filter = try container.decodeIfPresent([String: RawJSON].self, forKey: .filter)
        self.followersPagination = try container.decodeIfPresent(PagerRequest.self, forKey: .followersPagination)
        self.followingPagination = try container.decodeIfPresent(PagerRequest.self, forKey: .followingPagination)
        self.interestWeights = try container.decodeIfPresent([String: Double].self, forKey: .interestWeights)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.memberPagination = try container.decodeIfPresent(PagerRequest.self, forKey: .memberPagination)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.view = try container.decodeIfPresent(String.self, forKey: .view)
        self.watch = try container.decodeIfPresent(Bool.self, forKey: .watch)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(externalRanking, forKey: .externalRanking)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(followersPagination, forKey: .followersPagination)
        try container.encodeIfPresent(followingPagination, forKey: .followingPagination)
        try container.encodeIfPresent(interestWeights, forKey: .interestWeights)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(memberPagination, forKey: .memberPagination)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encodeIfPresent(view, forKey: .view)
        try container.encodeIfPresent(watch, forKey: .watch)
    }
}

extension GetOrCreateFeedRequest: Hashable {
    public static func == (lhs: GetOrCreateFeedRequest, rhs: GetOrCreateFeedRequest) -> Bool {
        lhs.data == rhs.data &&
            lhs.externalRanking == rhs.externalRanking &&
            lhs.filter == rhs.filter &&
            lhs.followersPagination == rhs.followersPagination &&
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
        hasher.combine(data)
        hasher.combine(externalRanking)
        hasher.combine(filter)
        hasher.combine(followersPagination)
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
