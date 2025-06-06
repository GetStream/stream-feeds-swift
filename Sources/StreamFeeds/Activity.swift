//
//  Activity.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 24.5.25.
//

import Foundation
import StreamCore

public class Activity: WSEventsSubscriber {
    
    private let apiClient: DefaultAPI
    private let activityId: String
    
    public internal(set) var state = ActivityState()
    
    init(id: String, apiClient: DefaultAPI) {
        self.apiClient = apiClient
        self.activityId = id
    }
    
    // MARK: - Comments
    
    public func queryComments(request: QueryCommentsRequest) async throws -> QueryCommentsResponse {
        let response = try await self.apiClient.queryComments(queryCommentsRequest: request)
        Task { @MainActor in
            state.comments = response.comments.map(\.toThreadedComment)
        }
        return response
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
    ) async throws -> GetCommentsResponse {
        let response = try await self.apiClient.getComments(
            objectId: objectId,
            objectType: objectType,
            depth: depth,
            sort: sort,
            repliesLimit: repliesLimit,
            limit: limit,
            prev: prev,
            next: next
        )
        Task { @MainActor in
            state.comments = response.comments
        }
        return response
    }
    
    @discardableResult
    public func addComment(request: AddCommentRequest) async throws -> AddCommentResponse {
        let response = try await self.apiClient.addComment(addCommentRequest: request)
        return response
    }
    
    @discardableResult
    public func addCommentsBatch(request: AddCommentsBatchRequest) async throws -> AddCommentsBatchResponse {
        let response = try await self.apiClient.addCommentsBatch(addCommentsBatchRequest: request)
        state.comments.append(contentsOf: response.comments.map(\.toThreadedComment))
        return response
    }
    
    @discardableResult
    public func deleteComment(commentId: String) async throws -> DeleteCommentResponse {
        let response = try await self.apiClient.deleteComment(commentId: commentId)
        Task { @MainActor in
            state.comments.removeAll { $0.id == commentId }
        }
        return response
    }
    
    public func getComment(commentId: String) async throws -> GetCommentResponse {
        let response = try await self.apiClient.getComment(commentId: commentId)
        if let index = state.comments.firstIndex(where: { $0.id == commentId }) {
            state.comments[index] = response.comment.toThreadedComment
        }
        return response
    }
    
    @discardableResult
    public func updateComment(commentId: String, request: UpdateCommentRequest) async throws -> UpdateCommentResponse {
        let response = try await self.apiClient.updateComment(commentId: commentId, updateCommentRequest: request)
        if let index = state.comments.firstIndex(where: { $0.id == commentId }) {
            Task { @MainActor in
                state.comments[index] = response.comment.toThreadedComment
            }
        }
        return response
    }
    
    @discardableResult
    public func removeCommentReaction(commentId: String, type: String) async throws -> DeleteCommentReactionResponse {
        let response = try await self.apiClient.removeCommentReaction(commentId: commentId, type: type)
        if let index = state.comments.firstIndex(where: { $0.id == commentId }) {
            state.comments[index].reactionCount -= 1
            state.comments[index].latestReactions?.removeAll(where: { $0.activityId == commentId })
        }
        return response
    }
    
    @discardableResult
    public func addCommentReaction(commentId: String, request: AddCommentReactionRequest) async throws -> AddCommentReactionResponse {
        let response = try await self.apiClient.addCommentReaction(commentId: commentId, addCommentReactionRequest: request)
        if let index = state.comments.firstIndex(where: { $0.id == commentId }) {
            state.comments[index].reactionCount += 1
            var latestReactions = state.comments[index].latestReactions ?? []
            latestReactions.append(response.reaction)
            state.comments[index].latestReactions = latestReactions
        }
        return response
    }
    
    public func getCommentReplies(
        commentId: String,
        depth: Int? = nil,
        sort: String? = nil,
        repliesLimit: Int? = nil,
        limit: Int? = nil,
        prev: String? = nil,
        next: String? = nil
    ) async throws -> GetCommentRepliesResponse {
        let response = try await self.apiClient.getCommentReplies(
            commentId: commentId,
            depth: depth,
            sort: sort,
            repliesLimit: repliesLimit,
            limit: limit,
            prev: prev,
            next: next
        )
        Task { @MainActor in
            if let index = state.comments.firstIndex(where: { $0.id == commentId }) {
                state.comments[index].replyCount = response.comments.count
            }
        }
        return response
    }
    
    // MARK: - Polls
    
    @discardableResult
    public func deletePoll(pollId: String, userId: String?) async throws -> Response {
        try await apiClient.deletePoll(pollId: pollId, userId: userId)
    }

    @discardableResult
    public func getPoll(pollId: String, userId: String?) async throws -> PollResponse {
        try await apiClient.getPoll(pollId: pollId, userId: userId)
    }

    @discardableResult
    public func updatePollPartial(
        pollId: String,
        updatePollPartialRequest: UpdatePollPartialRequest
    ) async throws -> PollResponse {
        try await apiClient.updatePollPartial(pollId: pollId, updatePollPartialRequest: updatePollPartialRequest)
    }

    @discardableResult
    public func createPollOption(
        pollId: String,
        createPollOptionRequest: CreatePollOptionRequest
    ) async throws -> PollOptionResponse {
        try await apiClient.createPollOption(pollId: pollId, createPollOptionRequest: createPollOptionRequest)
    }

    @discardableResult
    public func updatePollOption(
        pollId: String,
        updatePollOptionRequest: UpdatePollOptionRequest
    ) async throws -> PollOptionResponse {
        try await apiClient.updatePollOption(
            pollId: pollId,
            updatePollOptionRequest: updatePollOptionRequest
        )
    }

    @discardableResult
    public func deletePollOption(
        pollId: String,
        optionId: String,
        userId: String?
    ) async throws -> Response {
        try await apiClient.deletePollOption(pollId: pollId, optionId: optionId, userId: userId)
    }

    @discardableResult
    public func getPollOption(
        pollId: String,
        optionId: String,
        userId: String?
    ) async throws -> PollOptionResponse {
        try await apiClient.getPollOption(pollId: pollId, optionId: optionId, userId: userId)
    }

    @discardableResult
    public func queryPollVotes(
        pollId: String,
        userId: String?,
        queryPollVotesRequest: QueryPollVotesRequest
    ) async throws -> PollVotesResponse {
        try await apiClient.queryPollVotes(pollId: pollId, userId: userId, queryPollVotesRequest: queryPollVotesRequest)
    }
    
    @discardableResult
    public func castPollVote(
        activityId: String,
        pollId: String,
        castPollVoteRequest: CastPollVoteRequest
    ) async throws -> PollVoteResponse {
        try await apiClient.castPollVote(activityId: activityId, pollId: pollId, castPollVoteRequest: castPollVoteRequest)
    }

    @discardableResult
    public func removePollVote(
        activityId: String,
        pollId: String,
        voteId: String,
        userId: String?
    ) async throws -> PollVoteResponse {
        try await apiClient.removePollVote(
            activityId: activityId,
            pollId: pollId,
            voteId: voteId,
            userId: userId
        )
    }
    
    @discardableResult
    public func closePoll(pollId: String) async throws -> PollResponse {
        try await apiClient.updatePollPartial(
            pollId: pollId,
            updatePollPartialRequest: .init(set: ["isClosed": .bool(true)])
        )
    }
    
    // MARK: - Internal
    
    func onEvent(_ event: any Event) {
        if let event = event as? CommentReactionAddedEvent {
            if let index = state.comments.firstIndex(where: { $0.id == event.comment.id }) {
                let comment = state.comments[index]
                var latestReactions = comment.latestReactions ?? []
                latestReactions.append(event.reaction)
                comment.latestReactions = latestReactions
                let reactionGroup = comment.reactionGroups?[event.reaction.type]
                var count = reactionGroup?.count ?? 0
                count += 1
                var reactionGroups = comment.reactionGroups ?? [:]
                reactionGroups[event.reaction.type] = .init(
                    count: count,
                    firstReactionAt: reactionGroup?.firstReactionAt ?? Date(),
                    lastReactionAt: Date()
                )
                comment.reactionGroups = reactionGroups
                Task { @MainActor in
                    state.comments[index] = comment
                }
            }
        } else if let event = event as? CommentAddedEvent {
            if let parentCommentId = event.comment.parentId {
                if let index = state.comments.firstIndex(where: { $0.id == parentCommentId }) {
                    let comment = state.comments[index]
                    var replies = comment.replies ?? []
                    replies.append(event.comment.toThreadedComment)
                    comment.replies = replies
                    Task { @MainActor in
                        state.comments[index] = comment
                    }
                }
            } else {
                add(comment: event.comment.toThreadedComment)
            }
        } else if let event = event as? CommentDeletedEvent {
            if let parentCommentId = event.comment.parentId {
                if let index = state.comments.firstIndex(where: { $0.id == parentCommentId }) {
                    let comment = state.comments[index]
                    var replies = comment.replies ?? []
                    replies.removeAll(where: { $0.id == event.comment.id })
                    comment.replies = replies
                    Task { @MainActor in
                        state.comments[index] = comment
                    }
                }
            } else {
                Task { @MainActor in
                    state.comments.removeAll { $0.id == event.comment.id }
                }
            }
        } else if let event = event as? CommentReactionDeletedEvent {
            if let index = state.comments.firstIndex(where: { $0.id == event.comment.id }) {
                let comment = state.comments[index]
                comment.latestReactions?.removeAll(where: { $0.user.id == event.reaction.user.id })
                state.comments[index] = comment
            }
        } else if let event = event as? CommentUpdatedEvent {
            if let parentCommentId = event.comment.parentId {
                if let index = state.comments.firstIndex(where: { $0.id == parentCommentId }) {
                    let comment = state.comments[index]
                    var replies = comment.replies ?? []
                    if let replyIndex = replies.firstIndex(where: { $0.id == event.comment.id }) {
                        replies[replyIndex] = event.comment.toThreadedComment
                        comment.replies = replies
                        Task { @MainActor in
                            state.comments[index] = comment
                        }
                    }
                }
            } else {
                Task { @MainActor in
                    if let index = state.comments.firstIndex(where: { $0.id == event.comment.id }) {
                        state.comments[index] = event.comment.toThreadedComment
                    }
                }
            }
        }
    }
    
    // MARK: - private
    
    private func add(comment: ThreadedCommentResponse) {
        Task { @MainActor in
            if !self.state.comments.map(\.id).contains(comment.id) {
                //TODO: consider sorting
                self.state.comments.append(comment)
            }
        }
    }
}
