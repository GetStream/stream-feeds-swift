//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

final class PollsRepository: Sendable {
    private let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    // MARK: - Poll
    
    func closePoll(pollId: String) async throws -> PollData {
        let response = try await apiClient.updatePollPartial(
            pollId: pollId,
            updatePollPartialRequest: .init(set: ["isClosed": .bool(true)])
        )
        return response.poll.toModel()
    }
    
    func createPoll(request: CreatePollRequest) async throws -> PollData {
        let response = try await apiClient.createPoll(createPollRequest: request)
        return response.poll.toModel()
    }

    func deletePoll(pollId: String, userId: String?) async throws {
        _ = try await apiClient.deletePoll(pollId: pollId, userId: userId)
    }

    func getPoll(pollId: String, userId: String?) async throws -> PollData {
        let response = try await apiClient.getPoll(pollId: pollId, userId: userId)
        return response.poll.toModel()
    }

    func updatePollPartial(
        pollId: String,
        request: UpdatePollPartialRequest
    ) async throws -> PollData {
        let response = try await apiClient.updatePollPartial(pollId: pollId, updatePollPartialRequest: request)
        return response.poll.toModel()
    }
    
    func updatePoll(request: UpdatePollRequest) async throws -> PollData {
        let response = try await apiClient.updatePoll(updatePollRequest: request)
        return response.poll.toModel()
    }

    // MARK: - Poll Options
    
    func createPollOption(
        pollId: String,
        request: CreatePollOptionRequest
    ) async throws -> PollOptionData {
        let response = try await apiClient.createPollOption(pollId: pollId, createPollOptionRequest: request)
        return response.pollOption.toModel()
    }

    func removePollOption(
        pollId: String,
        optionId: String,
        userId: String?
    ) async throws {
        _ = try await apiClient.deletePollOption(pollId: pollId, optionId: optionId, userId: userId)
    }

    func getPollOption(
        pollId: String,
        optionId: String,
        userId: String?
    ) async throws -> PollOptionData {
        let response = try await apiClient.getPollOption(pollId: pollId, optionId: optionId, userId: userId)
        return response.pollOption.toModel()
    }

    func updatePollOption(
        pollId: String,
        request: UpdatePollOptionRequest
    ) async throws -> PollOptionData {
        let response = try await apiClient.updatePollOption(
            pollId: pollId,
            updatePollOptionRequest:         request
        )
        return response.pollOption.toModel()
    }

    // MARK: - Poll Lists
    
    func queryPolls(with query: PollsQuery) async throws -> PaginationResult<PollData> {
        let response = try await apiClient.queryPolls(userId: nil, queryPollsRequest: query.toRequest())
        return PaginationResult(
            models: response.polls.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
    
    // MARK: - Poll Votes
    
    func castPollVote(
        activityId: String,
        pollId: String,
        request: CastPollVoteRequest
    ) async throws -> PollVoteData? {
        let response = try await apiClient.castPollVote(activityId: activityId, pollId: pollId, castPollVoteRequest: request)
        // TODO: Optional
        guard let vote = response.vote else { return nil }
        return vote.toModel()
    }

    func queryPollVotes(
        pollId: String,
        userId: String?,
        request: QueryPollVotesRequest
    ) async throws -> PaginationResult<PollVoteData> {
        let response = try await apiClient.queryPollVotes(pollId: pollId, userId: userId, queryPollVotesRequest: request)
        return PaginationResult(
            models: response.votes.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
    
    func removePollVote(
        activityId: String,
        pollId: String,
        voteId: String,
        userId: String?
    ) async throws -> PollVoteData? {
        let response = try await apiClient.removePollVote(
            activityId: activityId,
            pollId: pollId,
            voteId: voteId,
            userId: userId
        )
        // TODO: Optional
        guard let vote = response.vote else { return nil }
        return vote.toModel()
    }
}
