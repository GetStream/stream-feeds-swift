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
    private let commentList: ActivityCommentList
    private let activitiesRepository: ActivitiesRepository
    private let commentsRepository: CommentsRepository
    private let pollsRepository: PollsRepository
    private let eventPublisher: StateLayerEventPublisher
    @MainActor private let stateBuilder: StateBuilder<ActivityState>
    
    /// The unique identifier of this activity.
    public let activityId: String
    
    /// The feed id for the activity.
    public let feed: FeedId
    
    init(
        id: String,
        feed: FeedId,
        data: ActivityData?,
        client: FeedsClient
    ) {
        let commentList = client.activityCommentList(
            for: .init(objectId: id, objectType: "activity", depth: 3)
        )
        self.commentList = commentList
        activityId = id
        activitiesRepository = client.activitiesRepository
        commentsRepository = client.commentsRepository
        eventPublisher = client.stateLayerEventPublisher
        self.feed = feed
        pollsRepository = client.pollsRepository
        let currentUserId = client.user.id
        stateBuilder = StateBuilder { [currentUserId, eventPublisher] in
            ActivityState(
                activityId: id,
                feed: feed,
                data: data,
                currentUserId: currentUserId,
                eventPublisher: eventPublisher,
                commentListState: commentList.state
            )
        }
    }
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the activity.
    @MainActor public var state: ActivityState { stateBuilder.state }
    
    /// Fetches the current state of the activity.
    ///
    /// This method retrieves the latest activity data and threaded comments from the server and updates the local state.
    /// - Returns: The data of the activity
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func get() async throws -> ActivityData {
        async let activity = activitiesRepository.getActivity(activityId: activityId)
        async let comments = queryComments()
        let (activityData, _) = try await (activity, comments)
        await state.setActivity(activityData)
        return activityData
    }
    
    // MARK: - Querying the List of Comments
    
    /// Queries comments for this activity.
    ///
    /// - Returns: An array of comment data matching the query criteria
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func queryComments() async throws -> [ThreadedCommentData] {
        try await commentList.get()
    }
    
    /// Loads the next page of comments if more are available.
    ///
    /// This method fetches additional comments using the pagination information
    /// from the previous request. If no more comments are available, an empty
    /// array is returned.
    ///
    /// - Parameter limit: Optional limit for the number of comments to fetch.
    ///   If not specified, uses the limit from the original query.
    /// - Returns: An array of `CommentData` representing the additional comments.
    ///   Returns an empty array if no more comments are available.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    @discardableResult
    public func queryMoreComments(limit: Int? = nil) async throws -> [ThreadedCommentData] {
        try await commentList.queryMoreComments(limit: limit)
    }
        
    /// Gets a specific comment by its identifier.
    ///
    /// - Parameter commentId: The unique identifier of the comment to retrieve
    /// - Returns: The comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func getComment(commentId: String) async throws -> CommentData {
        let comment = try await commentsRepository.getComment(commentId: commentId)
        await commentList.state.changeHandlers.commentUpdated(comment)
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
        await commentList.state.changeHandlers.commentAdded(ThreadedCommentData(from: comment))
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
        let threaded = comments.map { ThreadedCommentData(from: $0) }
        await commentList.state.access { state in
            threaded.forEach { state.changeHandlers.commentAdded($0) }
        }
        return comments
    }
    
    /// Removes a comment from this activity.
    ///
    /// - Parameter commentId: The unique identifier of the comment to remove
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deleteComment(commentId: String, hardDelete: Bool? = nil) async throws {
        try await commentsRepository.deleteComment(commentId: commentId, hardDelete: hardDelete)
        await commentList.state.changeHandlers.commentRemoved(commentId)
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
        await commentList.state.changeHandlers.commentUpdated(comment)
        return comment
    }
    
    // MARK: - Activity and Comment Reactions
    
    /// Adds a reaction to an activity.
    ///
    /// - Parameter request: The request containing the reaction data
    /// - Returns: The created reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addReaction(request: AddReactionRequest) async throws -> FeedsReactionData {
        let result = try await activitiesRepository.addReaction(activityId: activityId, request: request)
        await eventPublisher.sendEvent(.activityUpdated(result.activity, feed))
        return result.reaction
    }
    
    /// Removes a reaction from an activity.
    ///
    /// - Parameter type: The type of reaction to remove
    /// - Returns: The removed reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func deleteReaction(type: String) async throws -> FeedsReactionData {
        let result = try await activitiesRepository.deleteReaction(activityId: activityId, type: type)
        await eventPublisher.sendEvent(.activityUpdated(result.activity, feed))
        return result.reaction
    }
    
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
        await commentList.state.changeHandlers.commentReactionAdded(result.reaction, result.commentId)
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
    public func deleteCommentReaction(commentId: String, type: String) async throws -> FeedsReactionData {
        let result = try await commentsRepository.deleteCommentReaction(commentId: commentId, type: type)
        await commentList.state.changeHandlers.commentReactionRemoved(result.reaction, result.commentId)
        return result.reaction
    }
    
    // MARK: - Pinning
    
    /// Pins an activity in the feed.
    ///
    /// - SeeAlso: ``FeedData/pinnedActivities``
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func pin() async throws {
        let activity = try await activitiesRepository.pin(true, activityId: activityId, in: feed)
        await eventPublisher.sendEvent(.activityUpdated(activity, feed))
    }
    
    /// Unpins an activity from the feed.
    ///
    /// - SeeAlso: ``FeedData/pinnedActivities``
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func unpin() async throws {
        let activity = try await activitiesRepository.pin(false, activityId: activityId, in: feed)
        await eventPublisher.sendEvent(.activityUpdated(activity, feed))
    }
    
    // MARK: - Polls
    
    /// Closes a poll, preventing further votes.
    ///
    /// - Returns: The updated poll data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func closePoll() async throws -> PollData {
        let poll = try await updatePollPartial(request: .init(set: ["is_closed": .bool(true)]))
        await eventPublisher.sendEvent(.pollUpdated(poll, feed))
        return poll
    }
    
    /// Deletes a poll.
    ///
    /// - Parameters:
    ///   - userId: Optional user identifier for authorization
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deletePoll(userId: String? = nil) async throws {
        let pollId = try await pollId()
        try await pollsRepository.deletePoll(pollId: pollId, userId: userId)
        await eventPublisher.sendEvent(.pollDeleted(pollId, feed))
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
        await eventPublisher.sendEvent(.pollUpdated(poll, feed))
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
        await eventPublisher.sendEvent(.pollUpdated(poll, feed))
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
        await eventPublisher.sendEvent(.pollUpdated(poll, feed))
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
        if var poll = await state.poll {
            poll.addOption(option)
            await eventPublisher.sendEvent(.pollUpdated(poll, feed))
        }
        return option
    }

    /// Removes a poll option.
    ///
    /// - Parameters:
    ///   - optionId: The unique identifier of the option to remove
    ///   - userId: Optional user identifier for authorization
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deletePollOption(
        optionId: String,
        userId: String? = nil
    ) async throws {
        try await pollsRepository.deletePollOption(pollId: pollId(), optionId: optionId, userId: userId)
        if var poll = await state.poll {
            poll.removeOption(withId: optionId)
            await eventPublisher.sendEvent(.pollUpdated(poll, feed))
        }
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
        let option = try await pollsRepository.getPollOption(pollId: pollId(), optionId: optionId, userId: userId)
        if var poll = await state.poll {
            poll.updateOption(option)
            await eventPublisher.sendEvent(.pollUpdated(poll, feed))
        }
        return option
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
        if var poll = await state.poll {
            poll.updateOption(option)
            await eventPublisher.sendEvent(.pollUpdated(poll, feed))
        }
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
            if var poll = await state.poll {
                await poll.castVote(vote, currentUserId: state.currentUserId)
                await eventPublisher.sendEvent(.pollUpdated(poll, feed))
            }
        }
        return vote
    }

    /// Removes a vote from a poll.
    ///
    /// - Parameters:
    ///   - voteId: The unique identifier of the vote to remove
    ///   - userId: Optional user identifier for authorization
    /// - Returns: The removed vote data, or `nil` if the vote was not found
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func deletePollVote(
        voteId: String,
        userId: String? = nil
    ) async throws -> PollVoteData? {
        let vote = try await pollsRepository.deletePollVote(
            activityId: activityId,
            pollId: pollId(),
            voteId: voteId,
            userId: userId
        )
        if let vote {
            if var poll = await state.poll {
                await poll.removeVote(vote, currentUserId: state.currentUserId)
                await eventPublisher.sendEvent(.pollUpdated(poll, feed))
            }
        }
        return vote
    }
}

// MARK: - Private

private extension Activity {
    func ensureLocalStateFetched() async throws -> ActivityData {
        if let activity = await state.activity {
            activity
        } else {
            try await get()
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
