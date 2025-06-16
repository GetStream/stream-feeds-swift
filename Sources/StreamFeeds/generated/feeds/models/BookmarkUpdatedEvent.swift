import Foundation
import StreamCore

public final class BookmarkUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var bookmark: BookmarkResponse
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    public var type: String = "feeds.bookmark.updated"
    public var user: UserResponseCommonFields?

    public init(bookmark: BookmarkResponse, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.bookmark = bookmark
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bookmark
        case createdAt = "created_at"
        case custom
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: BookmarkUpdatedEvent, rhs: BookmarkUpdatedEvent) -> Bool {
        lhs.bookmark == rhs.bookmark &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmark)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
