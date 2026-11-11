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
    /// Whether the group has been read.
    ///
    /// - Important: Only set by ``Feed/getOrCreate()`` and ``Feed/queryMoreActivities(limit:)`` for feed groups that track seen and read state. No request property turns it on.
    public var isRead: Bool?
    /// Whether the group has been seen.
    ///
    /// - Important: Only set by ``Feed/getOrCreate()`` and ``Feed/queryMoreActivities(limit:)`` for feed groups that track seen and read state. No request property turns it on.
    public var isSeen: Bool?
    /// Whether all activities in the group have been read or seen.
    ///
    /// - Important: Only set by ``Feed/getOrCreate()`` and ``Feed/queryMoreActivities(limit:)`` for feed groups that track seen and read state. No request property turns it on.
    public var isWatched: Bool?
    public var score: Double
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
            isRead: isRead,
            isSeen: isSeen,
            isWatched: isWatched,
            score: score,
            updatedAt: updatedAt,
            userCount: userCount,
            userCountTruncated: userCountTruncated
        )
    }
}
