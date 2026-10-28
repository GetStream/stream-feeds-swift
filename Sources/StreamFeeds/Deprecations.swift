//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

// MARK: - Activity

extension Activity {
    /// Deletes a poll.
    @available(*, deprecated, renamed: "deletePoll()", message: "The API no longer accepts userId.")
    public func deletePoll(userId: String?) async throws {
        try await deletePoll()
    }

    /// Gets a specific poll by its identifier.
    @available(*, deprecated, renamed: "getPoll()", message: "The API no longer accepts userId.")
    @discardableResult
    public func getPoll(userId: String?) async throws -> PollData {
        try await getPoll()
    }

    /// Removes an option from a poll.
    @available(*, deprecated, renamed: "deletePollOption(optionId:)", message: "The API no longer accepts userId.")
    public func deletePollOption(optionId: String, userId: String?) async throws {
        try await deletePollOption(optionId: optionId)
    }

    /// Gets a specific poll option by its identifier.
    @available(*, deprecated, renamed: "getPollOption(optionId:)", message: "The API no longer accepts userId.")
    @discardableResult
    public func getPollOption(optionId: String, userId: String?) async throws -> PollOptionData {
        try await getPollOption(optionId: optionId)
    }

    /// Removes a vote from a poll.
    @available(*, deprecated, renamed: "deletePollVote(voteId:)", message: "The API no longer accepts userId.")
    @discardableResult
    public func deletePollVote(voteId: String, userId: String?) async throws -> PollVoteData? {
        try await deletePollVote(voteId: voteId)
    }
}

// MARK: - Feed

extension Feed {
    /// Accepts a follow request from another feed.
    @available(*, deprecated, renamed: "acceptFollow(_:)", message: "The API no longer accepts role.")
    @discardableResult
    public func acceptFollow(_ sourceFid: FeedId, role: String?) async throws -> FollowData {
        try await acceptFollow(sourceFid)
    }
}

// MARK: - FeedQuery

extension FeedQuery {
    /// Custom options for activity selection and processing.
    @available(*, deprecated, message: "The API no longer accepts activitySelectorOptions. The value is ignored.")
    public var activitySelectorOptions: [String: RawJSON]? {
        get { nil }
        set {}
    }

    /// Creates a new feed query with the specified group and ID.
    @available(*, deprecated, renamed: "init(group:id:activityFilter:activityLimit:data:externalRanking:followerLimit:followingLimit:interestWeights:memberLimit:view:watch:)", message: "The API no longer accepts activitySelectorOptions.")
    public init(
        group: String,
        id: String,
        activityFilter: ActivitiesFilter? = nil,
        activityLimit: Int? = nil,
        activitySelectorOptions: [String: RawJSON]?,
        data: FeedInput? = nil,
        externalRanking: [String: RawJSON]? = nil,
        followerLimit: Int? = nil,
        followingLimit: Int? = nil,
        interestWeights: [String: Float]? = nil,
        memberLimit: Int? = nil,
        view: String? = nil,
        watch: Bool = true
    ) {
        self.init(
            group: group,
            id: id,
            activityFilter: activityFilter,
            activityLimit: activityLimit,
            data: data,
            externalRanking: externalRanking,
            followerLimit: followerLimit,
            followingLimit: followingLimit,
            interestWeights: interestWeights,
            memberLimit: memberLimit,
            view: view,
            watch: watch
        )
    }

    /// Creates a new feed query with the specified feed ID.
    @available(*, deprecated, renamed: "init(feed:activityFilter:activityLimit:data:externalRanking:followerLimit:followingLimit:interestWeights:memberLimit:view:watch:)", message: "The API no longer accepts activitySelectorOptions.")
    public init(
        feed: FeedId,
        activityFilter: ActivitiesFilter? = nil,
        activityLimit: Int? = nil,
        activitySelectorOptions: [String: RawJSON]?,
        data: FeedInput? = nil,
        externalRanking: [String: RawJSON]? = nil,
        followerLimit: Int? = nil,
        followingLimit: Int? = nil,
        interestWeights: [String: Float]? = nil,
        memberLimit: Int? = nil,
        view: String? = nil,
        watch: Bool = true
    ) {
        self.init(
            feed: feed,
            activityFilter: activityFilter,
            activityLimit: activityLimit,
            data: data,
            externalRanking: externalRanking,
            followerLimit: followerLimit,
            followingLimit: followingLimit,
            interestWeights: interestWeights,
            memberLimit: memberLimit,
            view: view,
            watch: watch
        )
    }
}

// MARK: - PollVotesQuery

extension PollVotesQuery {
    /// Optional user ID used for authentication.
    @available(*, deprecated, message: "The API no longer accepts userId. The value is ignored.")
    public var userId: String? {
        get { nil }
        set {}
    }

    /// Creates a new poll votes query with the specified parameters.
    @available(*, deprecated, renamed: "init(pollId:filter:sort:limit:next:previous:)", message: "The API no longer accepts userId.")
    public init(
        pollId: String,
        userId: String?,
        filter: PollVotesFilter? = nil,
        sort: [Sort<PollVotesSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.init(
            pollId: pollId,
            filter: filter,
            sort: sort,
            limit: limit,
            next: next,
            previous: previous
        )
    }
}

// MARK: - ReactionGroupData

extension ReactionGroupData {
    /// The sum of the reaction scores in the group.
    @available(*, deprecated, message: "The API no longer returns sumScores. Always nil.")
    public var sumScores: Int? { nil }
}

// MARK: - UserData

extension UserData {
    /// The date before which the user's tokens were revoked.
    @available(*, deprecated, message: "The API does not return revokeTokensIssuedBefore for client-side requests. Always nil.")
    public var revokeTokensIssuedBefore: Date? { nil }
}

// MARK: - Renamed Models

/// Renamed to ``Location``.
@available(*, deprecated, renamed: "Location")
public typealias ActivityLocation = Location

/// Renamed to ``AIVideoConfigResponse``.
@available(*, deprecated, renamed: "AIVideoConfigResponse")
public typealias AIVideoConfig = AIVideoConfigResponse

/// Renamed to ``ModerationBanResponse``.
@available(*, deprecated, renamed: "ModerationBanResponse")
public typealias BanResponse = ModerationBanResponse

/// Renamed to ``FlagItemResponse``.
@available(*, deprecated, renamed: "FlagItemResponse")
public typealias FlagResponse = FlagItemResponse

extension AddActivityRequest {
    /// Renamed to ``ActivityVisibility``.
    @available(*, deprecated, renamed: "ActivityVisibility")
    public typealias AddActivityRequestVisibility = ActivityVisibility
}

extension FollowRequest {
    /// Renamed to ``FollowPushPreference``.
    @available(*, deprecated, renamed: "FollowPushPreference")
    public typealias FollowRequestPushPreference = FollowPushPreference
}
