//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ActivityPinData: Sendable {
    public let activity: ActivityData
    public let createdAt: Date
    public let fid: FeedId
    public let updatedAt: Date
    public let user: UserData
}

// MARK: - Model Conversions

extension ActivityPinResponse {
    func toModel() -> ActivityPinData {
        ActivityPinData(
            activity: activity.toModel(),
            createdAt: createdAt,
            fid: FeedId(rawValue: feed),
            updatedAt: updatedAt,
            user: user.toModel()
        )
    }
}
