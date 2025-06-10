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
    
    func queryComments(request: QueryCommentsRequest) async throws -> QueryCommentsData {
        let response = try await self.apiClient.queryComments(queryCommentsRequest: request)
        return QueryCommentsData(
            comments: response.comments.map(CommentInfo.init(from:)),
            next: response.next,
            prev: response.prev
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
    ) async throws -> [CommentInfo] {
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
        return response.comments.map(CommentInfo.init(from:))
    }
    
    // MARK: - Adding, Updating, and Removing Comments
    
    func addComment(request: AddCommentRequest) async throws -> CommentInfo {
        let response = try await self.apiClient.addComment(addCommentRequest: request)
        return CommentInfo(from: response.comment)
    }
    
    func addCommentsBatch(request: AddCommentsBatchRequest) async throws -> [CommentInfo] {
        let response = try await self.apiClient.addCommentsBatch(addCommentsBatchRequest: request)
        return response.comments.map(CommentInfo.init(from:))
    }
    
    func deleteComment(commentId: String) async throws {
        _ = try await self.apiClient.deleteComment(commentId: commentId)
    }
    
    func getComment(commentId: String) async throws -> CommentInfo {
        let response = try await self.apiClient.getComment(commentId: commentId)
        return CommentInfo(from: response.comment)
    }
    
    func updateComment(commentId: String, request: UpdateCommentRequest) async throws -> CommentInfo {
        let response = try await self.apiClient.updateComment(commentId: commentId, updateCommentRequest: request)
        return CommentInfo(from: response.comment)
    }
    
    // MARK: - Comment Reactions
    
    func addCommentReaction(commentId: String, request: AddCommentReactionRequest) async throws -> (reaction: FeedsReactionInfo, comment: CommentInfo) {
        let response = try await self.apiClient.addCommentReaction(commentId: commentId, addCommentReactionRequest: request)
        return (FeedsReactionInfo(from: response.reaction), CommentInfo(from: response.comment))
    }

    func removeCommentReaction(commentId: String, type: String) async throws -> (reaction: FeedsReactionInfo, comment: CommentInfo) {
        let response = try await self.apiClient.removeCommentReaction(commentId: commentId, type: type)
        return (FeedsReactionInfo(from: response.reaction), CommentInfo(from: response.comment))
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
    ) async throws -> [CommentInfo] {
        let response = try await self.apiClient.getCommentReplies(
            commentId: commentId,
            depth: depth,
            sort: sort,
            repliesLimit: repliesLimit,
            limit: limit,
            prev: prev,
            next: next
        )
        return response.comments.map(CommentInfo.init(from:))
    }
}

extension CommentsRepository {
    struct QueryCommentsData {
        let comments: [CommentInfo]
        let next: String?
        let prev: String?
    }
}
