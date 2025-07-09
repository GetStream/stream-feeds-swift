//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CommentList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<CommentListState>
    private let commentsRepository: CommentsRepository
    
    init(query: CommentsQuery, client: FeedsClient) {
        commentsRepository = client.commentsRepository
        self.query = query
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { CommentListState(query: query, events: events) }
    }

    public let query: CommentsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the comment list.
    @MainActor public var state: CommentListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Comments
    
    @discardableResult
    public func get() async throws -> [CommentData] {
        try await queryComments(with: query)
    }
    
    public func queryMoreComments(limit: Int? = nil) async throws -> [CommentData] {
        let nextQuery: CommentsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return CommentsQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryComments(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryComments(with query: CommentsQuery) async throws -> [CommentData] {
        let result = try await commentsRepository.queryComments(request: query.toRequest())
        await state.didPaginate(
            with: result,
            filter: query.filter,
            sort: query.sort
        )
        return result.models
    }
}
