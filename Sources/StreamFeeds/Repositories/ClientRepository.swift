//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

final class ClientRepository: Sendable {
    private let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    func getApp() async throws -> AppData {
        let response = try await apiClient.getApp()
        return response.app.toModel()
    }
}
