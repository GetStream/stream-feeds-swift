//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation

public struct NotificationStatusData: Equatable, Sendable {
    public let lastReadAt: Date?
    public let lastSeenAt: Date?
    public private(set) var readActivities: Set<String>
    public let seenActivities: Set<String>
    public private(set) var unread: Int
    public let unseen: Int
}

extension NotificationStatusData {
    mutating func addReadActivities(_ activityIds: Set<String>) {
        let uniqueIds = activityIds.subtracting(readActivities)
        readActivities.formUnion(activityIds)
        unread = max(0, unread - uniqueIds.count)
    }
    
    mutating func setAllRead(_ activityIds: Set<String>) {
        readActivities = activityIds
        unread = 0
    }
}

extension NotificationStatusResponse {
    func toModel() -> NotificationStatusData {
        NotificationStatusData(
            lastReadAt: lastReadAt,
            lastSeenAt: lastSeenAt,
            readActivities: Set(readActivities ?? []),
            seenActivities: Set(seenActivities ?? []),
            unread: unread,
            unseen: unseen
        )
    }
}
