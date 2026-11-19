//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_09_Moderation {
    var client: FeedsClient!

    func moderationClient(apiKey: APIKey, user: User, token: UserToken) {
        let client = FeedsClient(apiKey: apiKey, user: user, token: token)
        let moderation = client.moderation

        suppressUnusedWarning(moderation)
    }

    func banUser() async throws {
        let banRequest = BanRequest(
            ipBan: false,
            reason: "Violation of community guidelines",
            shadow: false,
            targetUserId: "user-123",
            timeout: 60 // 1 hour in minutes
        )

        let response = try await client.moderation.ban(banRequest: banRequest)

        suppressUnusedWarning(response)
    }

    func blockUser() async throws {
        let blockRequest = BlockUsersRequest(blockedUserId: "user-123")
        let response = try await client.moderation.blockUsers(blockUsersRequest: blockRequest)

        suppressUnusedWarning(response)
    }

    func unblockUser() async throws {
        let unblockRequest = UnblockUsersRequest(blockedUserId: "user-123")
        let response = try await client.moderation.unblockUsers(unblockUsersRequest: unblockRequest)

        suppressUnusedWarning(response)
    }

    func blockedUsers() async throws {
        let blockedUsers = try await client.moderation.getBlockedUsers()
        for block in blockedUsers.blocks {
            print("Blocked user: \(block.blockedUserId)")
        }
    }

    func flagContent() async throws {
        let flagRequest = FlagRequest(
            entityId: "activity-123",
            entityType: "stream:feeds:v3:activity",
            reason: "Inappropriate content"
        )

        let response = try await client.moderation.flag(flagRequest: flagRequest)

        suppressUnusedWarning(response)
    }

    func submitAction() async throws {
        let actionRequest = SubmitActionRequest(
            actionType: .markReviewed,
            itemId: "item-123"
        )

        let response = try await client.moderation.submitAction(submitActionRequest: actionRequest)

        suppressUnusedWarning(response)
    }

    func queryReviewQueue() async throws {
        let queryRequest = QueryReviewQueueRequest(
            // Query parameters for filtering and pagination
        )

        let reviewQueue = try await client.moderation.queryReviewQueue(queryReviewQueueRequest: queryRequest)

        suppressUnusedWarning(reviewQueue)
    }

    func upsertConfig() async throws {
        let configRequest = UpsertConfigRequest(
            key: "feeds"
            // Configuration details
        )

        let response = try await client.moderation.upsertConfig(upsertConfigRequest: configRequest)

        suppressUnusedWarning(response)
    }

    func getConfig() async throws {
        let config = try await client.moderation.getConfig(key: "automod_settings", team: "team-123")

        suppressUnusedWarning(config)
    }

    func deleteConfig() async throws {
        let response = try await client.moderation.deleteConfig(key: "automod_settings", team: "team-123")

        suppressUnusedWarning(response)
    }

    func queryModerationConfigs() async throws {
        let queryRequest = QueryModerationConfigsRequest(
            // Query parameters for filtering and pagination
        )

        let configs = try await client.moderation.queryModerationConfigs(queryModerationConfigsRequest: queryRequest)

        suppressUnusedWarning(configs)
    }

    func errorHandling(banRequest: BanRequest) async {
        do {
            _ = try await client.moderation.ban(banRequest: banRequest)
            print("User banned successfully")
        } catch {
            print("Failed to ban user: \(error)")
        }
    }
}
