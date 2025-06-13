//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct PaginationData: Sendable {
    public let next: String?
    public let previous: String?
}

struct PaginationResult<Model>: Sendable where Model: Sendable {
    let models: [Model]
    let pagination: PaginationData
}

// MARK: - Model Conversions

extension PagerResponse {
    func toModel() -> PaginationData {
        PaginationData(next: next, previous: prev)
    }
}
