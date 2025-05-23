import Foundation
import StreamCore

public final class NotificationStatusResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var lastSeenAt: Date?
    public var readActivities: [String]?
    public var unread: Int
    public var unseen: Int

    public init(lastSeenAt: Date? = nil, readActivities: [String]? = nil, unread: Int, unseen: Int) {
        self.lastSeenAt = lastSeenAt
        self.readActivities = readActivities
        self.unread = unread
        self.unseen = unseen
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case lastSeenAt = "last_seen_at"
        case readActivities = "read_activities"
        case unread
        case unseen
    }

    public static func == (lhs: NotificationStatusResponse, rhs: NotificationStatusResponse) -> Bool {
        lhs.lastSeenAt == rhs.lastSeenAt &&
            lhs.readActivities == rhs.readActivities &&
            lhs.unread == rhs.unread &&
            lhs.unseen == rhs.unseen
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(lastSeenAt)
        hasher.combine(readActivities)
        hasher.combine(unread)
        hasher.combine(unseen)
    }
}
