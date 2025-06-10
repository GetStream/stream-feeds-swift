//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Activity: Sendable {
    private let activitiesRepository: ActivitiesRepository
    private let commentsRepository: CommentsRepository
    private let pollsRepository: PollsRepository
    @MainActor private let stateBuilder: StateBuilder<ActivityState>
    public let activityId: String
    
    init(
        id: String,
        feedsId: String,
        activitiesRepository: ActivitiesRepository,
        commentsRepository: CommentsRepository,
        pollsRepository: PollsRepository,
        events: WSEventsSubscribing
    ) {
        self.activityId = id
        self.activitiesRepository = activitiesRepository
        self.commentsRepository = commentsRepository
        self.pollsRepository = pollsRepository
        self.stateBuilder = StateBuilder { ActivityState(activityId: id, feedsId: feedsId, events: events) }
    }
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the activity.
    @MainActor public var state: ActivityState { stateBuilder.state }
    
    /// Fetches the state of the activity.
    public func get() async throws {
        let activity = try await activitiesRepository.getActivity(activityId: activityId)
        await state.updateActivity(activity)
    }
    
    // MARK: - Querying the List of Comments
    
    @discardableResult
    public func queryComments(request: QueryCommentsRequest) async throws -> [CommentInfo] {
        let data = try await commentsRepository.queryComments(request: request)
        await state.update(with: data)
        return data.comments
    }
    
    public func getComments(
        objectId: String,
        objectType: String,
        depth: Int? = nil,
        sort: String? = nil,
        repliesLimit: Int? = nil,
        limit: Int? = nil,
        prev: String? = nil,
        next: String? = nil
    ) async throws -> [CommentInfo] {
        let comments = try await commentsRepository.getComments(
            objectId: objectId,
            objectType: objectType,
            depth: depth,
            sort: sort,
            repliesLimit: repliesLimit,
            limit: limit,
            prev: prev,
            next: next
        )
        // TODO: Pagination support
        await state.update { $0.comments = comments }
        return comments
    }
    
    public func getComment(commentId: String) async throws -> CommentInfo {
        let comment = try await commentsRepository.getComment(commentId: commentId)
        await state.changeHandlers.commentUpdated(comment)
        return comment
    }
    
    // MARK: - Adding, Updating, and Removing Comments
    
    @discardableResult
    public func addComment(request: AddCommentRequest) async throws -> CommentInfo {
        let comment = try await commentsRepository.addComment(request: request)
        await state.changeHandlers.commentAdded(comment)
        return comment
    }
    
    @discardableResult
    public func addCommentsBatch(request: AddCommentsBatchRequest) async throws -> [CommentInfo] {
        let comments = try await commentsRepository.addCommentsBatch(request: request)
        await state.update { state in
            comments.forEach { state.changeHandlers.commentAdded($0) }
        }
        return comments
    }
    
    public func deleteComment(commentId: String) async throws {
        try await commentsRepository.deleteComment(commentId: commentId)
        // TODO: state update with nesting and id
    }
    
    @discardableResult
    public func updateComment(commentId: String, request: UpdateCommentRequest) async throws -> CommentInfo {
        let comment = try await commentsRepository.updateComment(commentId: commentId, request: request)
        await state.changeHandlers.commentUpdated(comment)
        return comment
    }
    
    // MARK: - Comment Reactions
    
    @discardableResult
    public func addCommentReaction(commentId: String, request: AddCommentReactionRequest) async throws -> FeedsReactionInfo {
        let result = try await commentsRepository.addCommentReaction(commentId: commentId, request: request)
        await state.changeHandlers.commentReactionAdded(result.reaction, result.comment)
        return result.reaction
    }

    @discardableResult
    public func removeCommentReaction(commentId: String, type: String) async throws -> FeedsReactionInfo {
        let result = try await commentsRepository.removeCommentReaction(commentId: commentId, type: type)
        await state.changeHandlers.commentReactionDeleted(result.reaction, result.comment)
        return result.reaction
    }
    
    // MARK: - Comment Replies
    
    public func getCommentReplies(
        commentId: String,
        depth: Int? = nil,
        sort: String? = nil,
        repliesLimit: Int? = nil,
        limit: Int? = nil,
        prev: String? = nil,
        next: String? = nil
    ) async throws -> [CommentInfo] {
        let comments = try await commentsRepository.getCommentReplies(
            commentId: commentId,
            depth: depth,
            sort: sort,
            repliesLimit: repliesLimit,
            limit: limit,
            prev: prev,
            next: next
        )
        await state.update { state in
            comments.forEach { state.changeHandlers.commentUpdated($0) }
        }
        return comments
    }
    
    // MARK: - Polls
    
    @discardableResult
    public func closePoll(pollId: String) async throws -> PollInfo {
        try await updatePollPartial(pollId: pollId, request: .init(set: ["isClosed": .bool(true)]))
    }
    
    public func deletePoll(pollId: String, userId: String?) async throws {
        try await pollsRepository.deletePoll(pollId: pollId, userId: userId)
        // TODO: set to nil?
    }

    @discardableResult
    public func getPoll(pollId: String, userId: String?) async throws -> PollInfo {
        let poll = try await pollsRepository.getPoll(pollId: pollId, userId: userId)
        await state.changeHandlers.pollUpdated(poll)
        return poll
    }

    @discardableResult
    public func updatePollPartial(
        pollId: String,
        request: UpdatePollPartialRequest
    ) async throws -> PollInfo {
        let poll = try await pollsRepository.updatePollPartial(pollId: pollId, request: request)
        await state.changeHandlers.pollUpdated(poll)
        return poll
    }
    
    // MARK: - Poll Options

    @discardableResult
    public func createPollOption(
        pollId: String,
        request: CreatePollOptionRequest
    ) async throws -> PollOptionInfo {
        let option = try await pollsRepository.createPollOption(pollId: pollId, request: request)
        await state.update { $0.poll?.addOption(option) }
        return option
    }

    public func deletePollOption(
        pollId: String,
        optionId: String,
        userId: String?
    ) async throws {
        try await pollsRepository.deletePollOption(pollId: pollId, optionId: optionId, userId: userId)
        await state.update { $0.poll?.removeOption(withId: optionId) }
    }

    @discardableResult
    public func getPollOption(
        pollId: String,
        optionId: String,
        userId: String?
    ) async throws -> PollOptionInfo {
        try await pollsRepository.getPollOption(pollId: pollId, optionId: optionId, userId: userId)
    }
    
    @discardableResult
    public func updatePollOption(
        pollId: String,
        request: UpdatePollOptionRequest
    ) async throws -> PollOptionInfo {
        let option = try await pollsRepository.updatePollOption(
            pollId: pollId,
            request: request
        )
        await state.update { $0.poll?.updateOption(option) }
        return option
    }
    
    // MARK: - Poll Votes
    
    @discardableResult
    public func castPollVote(
        activityId: String,
        pollId: String,
        request: CastPollVoteRequest
    ) async throws -> PollVoteInfo? {
        let vote = try await pollsRepository.castPollVote(activityId: activityId, pollId: pollId, request: request)
        if let vote {
            await state.update { $0.poll?.castVote(vote) }
        }
        return vote
    }

    @discardableResult
    public func queryPollVotes(
        pollId: String,
        userId: String?,
        request: QueryPollVotesRequest
    ) async throws -> [PollVoteInfo] {
        try await pollsRepository.queryPollVotes(pollId: pollId, userId: userId, request: request)
    }

    @discardableResult
    public func removePollVote(
        activityId: String,
        pollId: String,
        voteId: String,
        userId: String?
    ) async throws -> PollVoteInfo? {
        let vote = try await pollsRepository.removePollVote(
            activityId: activityId,
            pollId: pollId,
            voteId: voteId,
            userId: userId
        )
        if let vote {
            await state.update { $0.poll?.removeVote(vote) }
        }
        return vote
    }
}
