//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

final class ActivitiesRepository: Sendable {
    private let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    // MARK: - Activities
    
    func addActivity(request: AddActivityRequest) async throws -> ActivityData {
        let response = try await apiClient.addActivity(addActivityRequest: request)
        return ActivityData(from: response.activity)
    }
        
    func deleteActivity(activityId: String, hardDelete: Bool) async throws {
        _ = try await apiClient.deleteActivity(activityId: activityId, hardDelete: hardDelete)
    }
    
    func getActivity(activityId: String) async throws -> ActivityData {
        let response = try await apiClient.getActivity(activityId: activityId)
        return ActivityData(from: response.activity)
    }

    func updateActivity(activityId: String, request: UpdateActivityRequest) async throws -> ActivityData {
        let response = try await apiClient.updateActivity(activityId: activityId, updateActivityRequest: request)
        return ActivityData(from: response.activity)
    }
    
    func markActivity(feedGroupId: String, feedId: String, request: MarkActivityRequest) async throws {
        _ = try await apiClient.markActivity(feedGroupId: feedGroupId, feedId: feedId, markActivityRequest: request)
    }
    
    // MARK: - Bookmarks
    
    func addBookmark(activityId: String) async throws -> BookmarkData {
        let response = try await apiClient.addBookmark(activityId: activityId, addBookmarkRequest: .init())
        return BookmarkData(from: response.bookmark)
    }
    
    func deleteBookmark(activityId: String) async throws -> BookmarkData {
        let response = try await apiClient.deleteBookmark(activityId: activityId)
        return BookmarkData(from: response.bookmark)
    }
    
    // MARK: - Reactions
    
    func addReaction(activityId: String, request: AddReactionRequest) async throws -> FeedsReactionData {
        let response = try await apiClient.addReaction(activityId: activityId, addReactionRequest: request)
        return FeedsReactionData(from: response.reaction)
    }
    
    func deleteReaction(activityId: String, type: String) async throws -> FeedsReactionData {
        let response = try await apiClient.deleteActivityReaction(activityId: activityId, type: type)
        return FeedsReactionData(from: response.reaction)
    }
}
