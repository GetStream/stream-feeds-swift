//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var duration: String
    public var mentionNotificationsCreated: Int?
    
    public init(activity: ActivityResponse, duration: String, mentionNotificationsCreated: Int? = nil) {
        self.activity = activity
        self.duration = duration
        self.mentionNotificationsCreated = mentionNotificationsCreated
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case duration
        case mentionNotificationsCreated = "mention_notifications_created"
    }
    
    public static func == (lhs: AddActivityResponse, rhs: AddActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
        lhs.duration == rhs.duration &&
        lhs.mentionNotificationsCreated == rhs.mentionNotificationsCreated
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
        hasher.combine(mentionNotificationsCreated)
    }
}
