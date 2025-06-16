import Foundation
import StreamCore

public final class FeedMemberUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var member: FeedMemberResponse
    public var receivedAt: Date?
    public var type: String = "feeds.feed_member.updated"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], fid: String, member: FeedMemberResponse, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.member = member
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case fid
        case member
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: FeedMemberUpdatedEvent, rhs: FeedMemberUpdatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.member == rhs.member &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(member)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
