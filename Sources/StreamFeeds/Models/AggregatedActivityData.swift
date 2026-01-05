//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct AggregatedActivityData: Identifiable, Equatable, Sendable {
    public var activities: [ActivityData]
    public var activityCount: Int
    public var createdAt: Date
    public var group: String
    public var score: Float
    public var updatedAt: Date
    public var userCount: Int
    public var userCountTruncated: Bool
    
    public var id: String {
        if let first = activities.first?.id {
            first
        } else {
            "\(activityCount)-\(userCount)-\(score)-\(createdAt)-(\(group))"
        }
    }
}

extension AggregatedActivityResponse {
    func toModel() -> AggregatedActivityData {
        AggregatedActivityData(
            activities: activities.map { $0.toModel() },
            activityCount: activityCount,
            createdAt: createdAt,
            group: group,
            score: score,
            updatedAt: updatedAt,
            userCount: userCount,
            userCountTruncated: userCountTruncated
        )
    }
}
