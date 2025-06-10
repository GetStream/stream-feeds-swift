//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

final class PollsRepository: Repository {
    func closePoll(pollId: String) async throws -> PollInfo {
        let response = try await apiClient.updatePollPartial(
            pollId: pollId,
            updatePollPartialRequest: .init(set: ["isClosed": .bool(true)])
        )
        return PollInfo(from: response.poll)
    }

    func deletePoll(pollId: String, userId: String?) async throws {
        _ = try await apiClient.deletePoll(pollId: pollId, userId: userId)
    }

    func getPoll(pollId: String, userId: String?) async throws -> PollInfo {
        let response = try await apiClient.getPoll(pollId: pollId, userId: userId)
        return PollInfo(from: response.poll)
    }

    func updatePollPartial(
        pollId: String,
        request: UpdatePollPartialRequest
    ) async throws -> PollInfo {
        let response = try await apiClient.updatePollPartial(pollId: pollId, updatePollPartialRequest: request)
        return PollInfo(from: response.poll)
    }

    // MARK: - Poll Options
    
    func createPollOption(
        pollId: String,
        request: CreatePollOptionRequest
    ) async throws -> PollOptionInfo {
        let response = try await apiClient.createPollOption(pollId: pollId, createPollOptionRequest: request)
        return PollOptionInfo(from: response.pollOption)
    }

    func deletePollOption(
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
    ) async throws -> PollOptionInfo {
        let response = try await apiClient.getPollOption(pollId: pollId, optionId: optionId, userId: userId)
        return PollOptionInfo(from: response.pollOption)
    }

    func updatePollOption(
        pollId: String,
        request: UpdatePollOptionRequest
    ) async throws -> PollOptionInfo {
        let response = try await apiClient.updatePollOption(
            pollId: pollId,
            updatePollOptionRequest:         request
        )
        return PollOptionInfo(from: response.pollOption)
    }

    // MARK: - Poll Votes
    
    func castPollVote(
        activityId: String,
        pollId: String,
        request: CastPollVoteRequest
    ) async throws -> PollVoteInfo? {
        let response = try await apiClient.castPollVote(activityId: activityId, pollId: pollId, castPollVoteRequest: request)
        // TODO: Optional
        guard let vote = response.vote else { return nil }
        return PollVoteInfo(from: vote)
    }

    func queryPollVotes(
        pollId: String,
        userId: String?,
        request: QueryPollVotesRequest
    ) async throws -> [PollVoteInfo] {
        let response = try await apiClient.queryPollVotes(pollId: pollId, userId: userId, queryPollVotesRequest: request)
        return response.votes.map(PollVoteInfo.init(from:))
    }
    
    func removePollVote(
        activityId: String,
        pollId: String,
        voteId: String,
        userId: String?
    ) async throws -> PollVoteInfo? {
        let response = try await apiClient.removePollVote(
            activityId: activityId,
            pollId: pollId,
            voteId: voteId,
            userId: userId
        )
        // TODO: Optional
        guard let vote = response.vote else { return nil }
        return PollVoteInfo(from: vote)
    }
}
