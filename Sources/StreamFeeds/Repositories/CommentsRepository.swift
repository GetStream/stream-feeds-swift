//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// A repository for managing comments.
///
/// Action methods make API requests and transform API responses to local models.
final class CommentsRepository: Sendable {
    private let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    // MARK: - Querying Comments
    
    func queryComments(request: QueryCommentsRequest) async throws -> PaginationResult<CommentData> {
        let response = try await apiClient.queryComments(queryCommentsRequest: request)
        return PaginationResult(
            models: response.comments.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
    
    func getComments(with query: ActivityCommentsQuery) async throws -> PaginationResult<ThreadedCommentData> {
        let response = try await apiClient.getComments(
            objectId: query.objectId,
            objectType: query.objectType,
            depth: query.depth,
            sort: query.sort?.rawValue,
            repliesLimit: query.repliesLimit,
            limit: query.limit,
            prev: query.previous,
            next: query.next
        )
        return PaginationResult(
            models: response.comments.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
    
    // MARK: - Adding, Updating, and Removing Comments
    
    func addComment(request: AddCommentRequest) async throws -> CommentData {
        let response = try await apiClient.addComment(addCommentRequest: request)
        return response.comment.toModel()
    }
    
    func addCommentsBatch(request: AddCommentsBatchRequest) async throws -> [CommentData] {
        let response = try await apiClient.addCommentsBatch(addCommentsBatchRequest: request)
        return response.comments.map { $0.toModel() }
    }
    
    func deleteComment(commentId: String) async throws {
        _ = try await apiClient.deleteComment(commentId: commentId)
    }
    
    func getComment(commentId: String) async throws -> CommentData {
        let response = try await apiClient.getComment(commentId: commentId)
        return response.comment.toModel()
    }
    
    func updateComment(commentId: String, request: UpdateCommentRequest) async throws -> CommentData {
        let response = try await apiClient.updateComment(commentId: commentId, updateCommentRequest: request)
        return response.comment.toModel()
    }
    
    // MARK: - Comment Reactions
    
    func addCommentReaction(commentId: String, request: AddCommentReactionRequest) async throws -> (reaction: FeedsReactionData, commentId: String) {
        let response = try await apiClient.addCommentReaction(commentId: commentId, addCommentReactionRequest: request)
        return (response.reaction.toModel(), response.comment.id)
    }

    func deleteCommentReaction(commentId: String, type: String) async throws -> (reaction: FeedsReactionData, commentId: String) {
        let response = try await apiClient.deleteCommentReaction(commentId: commentId, type: type)
        return (response.reaction.toModel(), response.comment.id)
    }
    
    // MARK: - Comment Reactions Pagination
    
    func queryCommentReactions(request: QueryCommentReactionsRequest, commentId: String) async throws -> PaginationResult<FeedsReactionData> {
        let response = try await apiClient.queryCommentReactions(commentId: commentId, queryCommentReactionsRequest: request)
        return PaginationResult(
            models: response.reactions.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
    
    // MARK: - Comment Replies
    
    func getCommentReplies(with query: CommentRepliesQuery) async throws -> PaginationResult<ThreadedCommentData> {
        let response = try await apiClient.getCommentReplies(
            commentId: query.commentId,
            depth: query.depth,
            sort: query.sort?.rawValue,
            repliesLimit: query.repliesLimit,
            limit: query.limit,
            prev: query.previous,
            next: query.next
        )
        return PaginationResult(
            models: response.comments.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
}
