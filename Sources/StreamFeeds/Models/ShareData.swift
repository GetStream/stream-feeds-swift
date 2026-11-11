//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A share of an activity.
public struct ShareData: Equatable, Sendable {
    /// The identifier of the activity that shares the original activity.
    public let activityId: String
    /// The date when the activity was shared.
    public let createdAt: Date
    /// The user who shared the activity.
    public let user: UserData
}

// MARK: - Model Conversions

extension ShareResponse {
    func toModel() -> ShareData {
        ShareData(
            activityId: activityId,
            createdAt: createdAt,
            user: user.toModel()
        )
    }
}
