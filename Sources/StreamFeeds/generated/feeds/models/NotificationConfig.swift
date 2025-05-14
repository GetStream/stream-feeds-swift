import Foundation
import StreamCore

public final class NotificationConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var trackRead: Bool?
    public var trackSeen: Bool?

    public init(trackRead: Bool? = nil, trackSeen: Bool? = nil) {
        self.trackRead = trackRead
        self.trackSeen = trackSeen
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case trackRead = "track_read"
        case trackSeen = "track_seen"
    }

    public static func == (lhs: NotificationConfig, rhs: NotificationConfig) -> Bool {
        lhs.trackRead == rhs.trackRead &&
            lhs.trackSeen == rhs.trackSeen
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(trackRead)
        hasher.combine(trackSeen)
    }
}
