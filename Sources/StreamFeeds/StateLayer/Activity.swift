//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A class representing a single activity in a feed.
///
/// This class provides methods to interact with an activity including fetching its data,
/// managing comments, handling reactions, and working with polls. It maintains an observable
/// state that automatically updates when WebSocket events are received.
public final class Activity: Sendable {
    private let activitiesRepository: ActivitiesRepository
    private let commentsRepository: CommentsRepository
    private let pollsRepository: PollsRepository
    @MainActor private let stateBuilder: StateBuilder<ActivityState>
    
    /// The unique identifier of this activity.
    public let activityId: String
    
    /// Initializes a new Activity instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the activity
    ///   - fid: The identifier of the feed containing this activity
    ///   - client: The feeds client instance.
    init(
        id: String,
        fid: FeedId,
        client: FeedsClient
    ) {
        self.activityId = id
        self.activitiesRepository = client.activitiesRepository
        self.commentsRepository = client.commentsRepository
        self.pollsRepository = client.pollsRepository
        let events = client.eventsMiddleware
        self.stateBuilder = StateBuilder { ActivityState(activityId: id, fid: fid, events: events) }
    }
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the activity.
    @MainActor public var state: ActivityState { stateBuilder.state }
    
    /// Fetches the current state of the activity.
    ///
    /// This method retrieves the latest activity data from the server and updates the local state.
    /// - Returns: The data of the activity
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func get() async throws -> ActivityData {
        let activity = try await activitiesRepository.getActivity(activityId: activityId)
        await state.updateActivity(activity)
        return activity
    }
    
    // MARK: - Querying the List of Comments
    
    /// Queries comments for this activity based on the provided request parameters.
    ///
    /// - Parameter request: The query request containing filtering and pagination parameters
    /// - Returns: An array of comment data matching the query criteria
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func queryComments(request: QueryCommentsRequest) async throws -> [CommentData] {
        let data = try await commentsRepository.queryComments(request: request)
        await state.update(with: data)
        return data.comments
    }
    
    /// Gets comments for a specific object with optional filtering and pagination.
    ///
    /// - Parameters:
    ///   - objectId: The unique identifier of the object to get comments for
    ///   - objectType: The type of object (e.g., "activity", "comment")
    ///   - depth: Optional depth for nested comment retrieval
    ///   - sort: Optional sorting criteria
    ///   - repliesLimit: Optional limit for the number of replies to include
    ///   - limit: Optional limit for the number of comments to return
    ///   - prev: Optional pagination token for previous page
    ///   - next: Optional pagination token for next page
    /// - Returns: An array of comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func getComments(
        objectId: String,
        objectType: String,
        depth: Int? = nil,
        sort: String? = nil,
        repliesLimit: Int? = nil,
        limit: Int? = nil,
        prev: String? = nil,
        next: String? = nil
    ) async throws -> [CommentData] {
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
        await state.access { $0.comments = comments }
        return comments
    }
    
    /// Gets a specific comment by its identifier.
    ///
    /// - Parameter commentId: The unique identifier of the comment to retrieve
    /// - Returns: The comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func getComment(commentId: String) async throws -> CommentData {
        let comment = try await commentsRepository.getComment(commentId: commentId)
        await state.changeHandlers.commentUpdated(comment)
        return comment
    }
    
    // MARK: - Adding, Updating, and Removing Comments
    
    /// Adds a new comment to this activity.
    ///
    /// - Parameter request: The request containing the comment data to add
    /// - Returns: The created comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addComment(request: ActivityAddCommentRequest) async throws -> CommentData {
        let comment = try await commentsRepository.addComment(request: request.withActivityId(activityId))
        await state.changeHandlers.commentAdded(comment)
        return comment
    }
    
    /// Adds multiple comments in a batch operation.
    ///
    /// - Parameter requests: The array of requests containing comments to add
    /// - Returns: An array of the created comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addCommentsBatch(requests: [ActivityAddCommentRequest]) async throws -> [CommentData] {
        let request = AddCommentsBatchRequest(comments: requests.map { $0.withActivityId(activityId) })
        let comments = try await commentsRepository.addCommentsBatch(request: request)
        await state.access { state in
            comments.forEach { state.changeHandlers.commentAdded($0) }
        }
        return comments
    }
    
    /// Removes a comment from this activity.
    ///
    /// - Parameter commentId: The unique identifier of the comment to remove
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func removeComment(commentId: String) async throws {
        try await commentsRepository.removeComment(commentId: commentId)
        // TODO: state update with nesting and id
    }
    
    /// Updates an existing comment.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the comment to update
    ///   - request: The request containing the updated comment data
    /// - Returns: The updated comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updateComment(commentId: String, request: UpdateCommentRequest) async throws -> CommentData {
        let comment = try await commentsRepository.updateComment(commentId: commentId, request: request)
        await state.changeHandlers.commentUpdated(comment)
        return comment
    }
    
    // MARK: - Comment Reactions
    
    /// Adds a reaction to a comment.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the comment to react to
    ///   - request: The request containing the reaction data
    /// - Returns: The created reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addCommentReaction(commentId: String, request: AddCommentReactionRequest) async throws -> FeedsReactionData {
        let result = try await commentsRepository.addCommentReaction(commentId: commentId, request: request)
        await state.changeHandlers.commentReactionAdded(result.reaction, result.comment)
        return result.reaction
    }

    /// Removes a reaction from a comment.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the comment
    ///   - type: The type of reaction to remove
    /// - Returns: The removed reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func removeCommentReaction(commentId: String, type: String) async throws -> FeedsReactionData {
        let result = try await commentsRepository.removeCommentReaction(commentId: commentId, type: type)
        await state.changeHandlers.commentReactionRemoved(result.reaction, result.comment)
        return result.reaction
    }
    
    // MARK: - Comment Replies
    
    /// Gets replies to a specific comment with optional filtering and pagination.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the parent comment
    ///   - depth: Optional depth for nested reply retrieval
    ///   - sort: Optional sorting criteria
    ///   - repliesLimit: Optional limit for the number of replies to include
    ///   - limit: Optional limit for the number of replies to return
    ///   - prev: Optional pagination token for previous page
    ///   - next: Optional pagination token for next page
    /// - Returns: An array of reply comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func getCommentReplies(
        commentId: String,
        depth: Int? = nil,
        sort: String? = nil,
        repliesLimit: Int? = nil,
        limit: Int? = nil,
        prev: String? = nil,
        next: String? = nil
    ) async throws -> [CommentData] {
        let comments = try await commentsRepository.getCommentReplies(
            commentId: commentId,
            depth: depth,
            sort: sort,
            repliesLimit: repliesLimit,
            limit: limit,
            prev: prev,
            next: next
        )
        await state.access { state in
            comments.forEach { state.changeHandlers.commentUpdated($0) }
        }
        return comments
    }
    
    // MARK: - Polls
    
    /// Closes a poll, preventing further votes.
    ///
    /// - Returns: The updated poll data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func closePoll() async throws -> PollData {
        try await updatePollPartial(request: .init(set: ["isClosed": .bool(true)]))
    }
    
    /// Deletes a poll.
    ///
    /// - Parameters:
    ///   - pollId: The unique identifier of the poll to delete
    ///   - userId: Optional user identifier for authorization
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deletePoll(pollId: String, userId: String?) async throws {
        try await pollsRepository.deletePoll(pollId: pollId, userId: userId)
        // TODO: set to nil?
    }

    /// Gets a specific poll by its identifier.
    ///
    /// - Parameters:
    ///   - userId: Optional user identifier for user-specific poll data
    /// - Returns: The poll data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func getPoll(userId: String? = nil) async throws -> PollData {
        let poll = try await pollsRepository.getPoll(pollId: pollId(), userId: userId)
        await state.changeHandlers.pollUpdated(poll)
        return poll
    }

    /// Updates a poll with partial data.
    ///
    /// - Parameters:
    ///   - pollId: The unique identifier of the poll to update
    ///   - request: The request containing the partial update data
    /// - Returns: The updated poll data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updatePollPartial(request: UpdatePollPartialRequest) async throws -> PollData {
        let poll = try await pollsRepository.updatePollPartial(pollId: pollId(), request: request)
        await state.changeHandlers.pollUpdated(poll)
        return poll
    }
    
    /// Updates a poll.
    ///
    /// - Parameters:
    ///   - request: The request containing the update data
    /// - Returns: The updated poll data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updatePoll(request: UpdatePollRequest) async throws -> PollData {
        let poll = try await pollsRepository.updatePoll(request: request)
        await state.changeHandlers.pollUpdated(poll)
        return poll
    }
    
    // MARK: - Poll Options

    /// Creates a new option for a poll.
    ///
    /// - Parameters:
    ///   - request: The request containing the poll option data
    /// - Returns: The created poll option data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func createPollOption(request: CreatePollOptionRequest) async throws -> PollOptionData {
        let option = try await pollsRepository.createPollOption(pollId: pollId(), request: request)
        await state.access { $0.poll?.addOption(option) }
        return option
    }

    /// Removes a poll option.
    ///
    /// - Parameters:
    ///   - optionId: The unique identifier of the option to remove
    ///   - userId: Optional user identifier for authorization
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func removePollOption(
        optionId: String,
        userId: String?
    ) async throws {
        try await pollsRepository.removePollOption(pollId: pollId(), optionId: optionId, userId: userId)
        await state.access { $0.poll?.removeOption(withId: optionId) }
    }

    /// Gets a specific poll option by its identifier.
    ///
    /// - Parameters:
    ///   - optionId: The unique identifier of the option to retrieve
    ///   - userId: Optional user identifier for user-specific option data
    /// - Returns: The poll option data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func getPollOption(
        optionId: String,
        userId: String?
    ) async throws -> PollOptionData {
        try await pollsRepository.getPollOption(pollId: pollId(), optionId: optionId, userId: userId)
    }
    
    /// Updates a poll option.
    ///
    /// - Parameters:
    ///   - request: The request containing the updated poll option data
    /// - Returns: The updated poll option data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updatePollOption(request: UpdatePollOptionRequest) async throws -> PollOptionData {
        let option = try await pollsRepository.updatePollOption(
            pollId: pollId(),
            request: request
        )
        await state.access { $0.poll?.updateOption(option) }
        return option
    }
    
    // MARK: - Poll Votes
    
    /// Casts a vote in a poll.
    ///
    /// - Parameters:
    ///   - request: The request containing the vote data
    /// - Returns: The created vote data, or `nil` if the vote was not created
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func castPollVote(request: CastPollVoteRequest) async throws -> PollVoteData? {
        let vote = try await pollsRepository.castPollVote(activityId: activityId, pollId: pollId(), request: request)
        if let vote {
            await state.access { $0.poll?.castVote(vote) }
        }
        return vote
    }

    /// Queries votes for a poll based on the provided request parameters.
    ///
    /// - Parameters:
    ///   - userId: Optional user identifier for user-specific vote data
    ///   - request: The query request containing filtering and pagination parameters
    /// - Returns: An array of poll vote data matching the query criteria
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func queryPollVotes(
        userId: String?,
        request: QueryPollVotesRequest
    ) async throws -> [PollVoteData] {
        try await pollsRepository.queryPollVotes(pollId: pollId(), userId: userId, request: request)
    }

    /// Removes a vote from a poll.
    ///
    /// - Parameters:
    ///   - voteId: The unique identifier of the vote to remove
    ///   - userId: Optional user identifier for authorization
    /// - Returns: The removed vote data, or `nil` if the vote was not found
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func removePollVote(
        voteId: String,
        userId: String?
    ) async throws -> PollVoteData? {
        let vote = try await pollsRepository.removePollVote(
            activityId: activityId,
            pollId: pollId(),
            voteId: voteId,
            userId: userId
        )
        if let vote {
            await state.access { $0.poll?.removeVote(vote) }
        }
        return vote
    }
}

// MARK: - Private

private extension Activity {
    func ensureLocalStateFetched() async throws -> ActivityData {
        if let activity = await state.activity {
            return activity
        } else {
            return try await get()
        }
    }
    
    func pollId() async throws -> String {
        if let pollId = try await ensureLocalStateFetched().poll?.id {
            return pollId
        } else {
            throw ClientError("Activity with id \(activityId) does not contain poll")
        }
    }
}
