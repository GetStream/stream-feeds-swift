import Foundation
import StreamCore

public final class BookmarkDeletedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var bookmark: Bookmark
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var receivedAt: Date?
    public var type: String = "bookmark.deleted"
    public var user: UserResponseCommonFields?

    public init(bookmark: Bookmark, createdAt: Date, custom: [String: RawJSON], fid: String, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.bookmark = bookmark
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bookmark
        case createdAt = "created_at"
        case custom
        case fid
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: BookmarkDeletedEvent, rhs: BookmarkDeletedEvent) -> Bool {
        lhs.bookmark == rhs.bookmark &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmark)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
