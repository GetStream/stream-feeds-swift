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
        let response = try await self.apiClient.queryComments(queryCommentsRequest: request)
        return PaginationResult(
            models: response.comments.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
    
    func getComments(
        objectId: String,
        objectType: String,
        depth: Int?,
        sort: String?,
        repliesLimit: Int?,
        limit: Int?,
        prev: String?,
        next: String?
    ) async throws -> [CommentData] {
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
        return response.comments.map { $0.toModel() }
    }
    
    // MARK: - Adding, Updating, and Removing Comments
    
    func addComment(request: AddCommentRequest) async throws -> CommentData {
        let response = try await self.apiClient.addComment(addCommentRequest: request)
        return response.comment.toModel()
    }
    
    func addCommentsBatch(request: AddCommentsBatchRequest) async throws -> [CommentData] {
        let response = try await self.apiClient.addCommentsBatch(addCommentsBatchRequest: request)
        return response.comments.map { $0.toModel() }
    }
    
    func deleteComment(commentId: String) async throws {
        _ = try await self.apiClient.deleteComment(commentId: commentId)
    }
    
    func getComment(commentId: String) async throws -> CommentData {
        let response = try await self.apiClient.getComment(commentId: commentId)
        return response.comment.toModel()
    }
    
    func updateComment(commentId: String, request: UpdateCommentRequest) async throws -> CommentData {
        let response = try await self.apiClient.updateComment(commentId: commentId, updateCommentRequest: request)
        return response.comment.toModel()
    }
    
    // MARK: - Comment Reactions
    
    func addCommentReaction(commentId: String, request: AddCommentReactionRequest) async throws -> (reaction: FeedsReactionData, comment: CommentData) {
        let response = try await self.apiClient.addCommentReaction(commentId: commentId, addCommentReactionRequest: request)
        return (response.reaction.toModel(), response.comment.toModel())
    }

    func deleteCommentReaction(commentId: String, type: String) async throws -> (reaction: FeedsReactionData, comment: CommentData) {
        let response = try await self.apiClient.deleteCommentReaction(commentId: commentId, type: type)
        return (response.reaction.toModel(), response.comment.toModel())
    }
    
    // MARK: - Comment Replies
    
    func getCommentReplies(
        commentId: String,
        depth: Int?,
        sort: String?,
        repliesLimit: Int?,
        limit: Int?,
        prev: String?,
        next: String?
    ) async throws -> [CommentData] {
        let response = try await self.apiClient.getCommentReplies(
            commentId: commentId,
            depth: depth,
            sort: sort,
            repliesLimit: repliesLimit,
            limit: limit,
            prev: prev,
            next: next
        )
        return response.comments.map { $0.toModel() }
    }
}
