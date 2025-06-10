//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedsReactionData: Sendable {
    public let activityId: String
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let type: String
    public let updatedAt: Date
    public let user: UserData
}

extension FeedsReactionData: Identifiable {
    public var id: String {
        activityId + user.id
    }
}

// MARK: - Model Conversions

extension FeedsReactionResponse {
    func toModel() -> FeedsReactionData {
        FeedsReactionData(
            activityId: activityId,
            createdAt: createdAt,
            custom: custom,
            type: type,
            updatedAt: updatedAt,
            user: user.toModel()
        )
    }
}
