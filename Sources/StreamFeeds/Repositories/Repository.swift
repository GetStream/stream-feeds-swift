//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// A base class for repositories.
class Repository {
    let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
}
