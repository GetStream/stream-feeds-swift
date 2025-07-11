//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// A repository for managing moderation configurations.
///
/// Action methods make API requests and transform API responses to local models.
final class ModerationRepository: Sendable {
    private let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    // MARK: - Querying Moderation Configurations
    
    /// Queries moderation configurations based on the provided query configuration.
    ///
    /// This method fetches moderation configurations from the server using the specified query parameters,
    /// including filtering, sorting, and pagination options.
    ///
    /// - Parameter query: The query configuration for fetching configurations
    /// - Returns: A paginated result containing configurations and pagination information
    /// - Throws: An error if the network request fails or the response cannot be parsed
    func queryModerationConfigs(with query: ModerationConfigsQuery) async throws -> PaginationResult<ModerationConfigData> {
        let request = query.toRequest()
        let response = try await apiClient.queryModerationConfigs(queryModerationConfigsRequest: request)
        return PaginationResult(
            models: response.configs.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev)
        )
    }
}
