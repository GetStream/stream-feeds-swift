//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public final class Moderation: Sendable {
    private let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    // MARK: - User Moderation
    
    /// Bans a user from the platform
    /// - Parameter banRequest: The ban request containing details about the user to ban and ban parameters
    /// - Returns: A `BanResponse` containing information about the ban duration
    /// - Throws: An error if the ban operation fails
    public func ban(banRequest: BanRequest) async throws -> BanResponse {
        return try await apiClient.ban(banRequest: banRequest)
    }
    
    /// Mutes one or more users
    /// - Parameter muteRequest: The mute request containing target user IDs and optional timeout
    /// - Returns: A `MuteResponse` containing information about the mute operation
    /// - Throws: An error if the mute operation fails
    public func mute(muteRequest: MuteRequest) async throws -> MuteResponse {
        return try await apiClient.mute(muteRequest: muteRequest)
    }
    
    /// Blocks a user
    /// - Parameter blockUsersRequest: The block request containing the user ID to block
    /// - Returns: A `BlockUsersResponse` containing information about the block operation
    /// - Throws: An error if the block operation fails
    public func blockUsers(blockUsersRequest: BlockUsersRequest) async throws -> BlockUsersResponse {
        return try await apiClient.blockUsers(blockUsersRequest: blockUsersRequest)
    }
    
    /// Unblocks a user
    /// - Parameter unblockUsersRequest: The unblock request containing the user ID to unblock
    /// - Returns: An `UnblockUsersResponse` containing information about the unblock operation
    /// - Throws: An error if the unblock operation fails
    public func unblockUsers(unblockUsersRequest: UnblockUsersRequest) async throws -> UnblockUsersResponse {
        return try await apiClient.unblockUsers(unblockUsersRequest: unblockUsersRequest)
    }
    
    /// Gets the list of blocked users
    /// - Returns: A `GetBlockedUsersResponse` containing the list of blocked users
    /// - Throws: An error if the operation fails
    public func getBlockedUsers() async throws -> GetBlockedUsersResponse {
        return try await apiClient.getBlockedUsers()
    }
    
    // MARK: - Content Moderation
    
    /// Flags content for moderation review
    /// - Parameter flagRequest: The flag request containing details about the content to flag
    /// - Returns: A `FlagResponse` containing information about the flag operation
    /// - Throws: An error if the flag operation fails
    public func flag(flagRequest: FlagRequest) async throws -> FlagResponse {
        return try await apiClient.flag(flagRequest: flagRequest)
    }
    
    /// Submits a moderation action
    /// - Parameter submitActionRequest: The action request containing details about the moderation action
    /// - Returns: A `SubmitActionResponse` containing information about the action submission
    /// - Throws: An error if the action submission fails
    public func submitAction(submitActionRequest: SubmitActionRequest) async throws -> SubmitActionResponse {
        return try await apiClient.submitAction(submitActionRequest: submitActionRequest)
    }
    
    // MARK: - Review Queue
    
    /// Queries the moderation review queue
    /// - Parameter queryReviewQueueRequest: The query request containing filters and pagination parameters
    /// - Returns: A `QueryReviewQueueResponse` containing the review queue items
    /// - Throws: An error if the query operation fails
    public func queryReviewQueue(queryReviewQueueRequest: QueryReviewQueueRequest) async throws -> QueryReviewQueueResponse {
        return try await apiClient.queryReviewQueue(queryReviewQueueRequest: queryReviewQueueRequest)
    }
    
    // MARK: - Configuration Management
    
    /// Upserts a moderation configuration
    /// - Parameter upsertConfigRequest: The configuration request containing the config to upsert
    /// - Returns: An `UpsertConfigResponse` containing information about the upsert operation
    /// - Throws: An error if the upsert operation fails
    public func upsertConfig(upsertConfigRequest: UpsertConfigRequest) async throws -> UpsertConfigResponse {
        return try await apiClient.upsertConfig(upsertConfigRequest: upsertConfigRequest)
    }
    
    /// Deletes a moderation configuration
    /// - Parameters:
    ///   - key: The configuration key to delete
    ///   - team: Optional team identifier
    /// - Returns: A `DeleteModerationConfigResponse` containing information about the deletion
    /// - Throws: An error if the deletion fails
    public func deleteConfig(key: String, team: String? = nil) async throws -> DeleteModerationConfigResponse {
        return try await apiClient.deleteConfig(key: key, team: team)
    }
    
    /// Gets a moderation configuration
    /// - Parameters:
    ///   - key: The configuration key to retrieve
    ///   - team: Optional team identifier
    /// - Returns: A `GetConfigResponse` containing the configuration
    /// - Throws: An error if the retrieval fails
    public func getConfig(key: String, team: String? = nil) async throws -> GetConfigResponse {
        return try await apiClient.getConfig(key: key, team: team)
    }
    
    /// Queries moderation configurations
    /// - Parameter queryModerationConfigsRequest: The query request containing filters and pagination parameters
    /// - Returns: A `QueryModerationConfigsResponse` containing the matching configurations
    /// - Throws: An error if the query operation fails
    public func queryModerationConfigs(queryModerationConfigsRequest: QueryModerationConfigsRequest) async throws -> QueryModerationConfigsResponse {
        return try await apiClient.queryModerationConfigs(queryModerationConfigsRequest: queryModerationConfigsRequest)
    }
}
