import Foundation
import StreamCore

public final class ActivityUnpinnedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var pinnedActivity: PinActivityResponse
    public var receivedAt: Date?
    public var type: String = "feeds.activity.unpinned"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], fid: String, pinnedActivity: PinActivityResponse, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.pinnedActivity = pinnedActivity
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case fid
        case pinnedActivity = "pinned_activity"
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: ActivityUnpinnedEvent, rhs: ActivityUnpinnedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.pinnedActivity == rhs.pinnedActivity &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(pinnedActivity)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
