import Foundation
import StreamCore

public final class FeedMemberRemovedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var memberId: String
    public var receivedAt: Date?
    public var type: String = "feed_member.removed"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], fid: String, memberId: String, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.memberId = memberId
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case fid
        case memberId = "member_id"
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: FeedMemberRemovedEvent, rhs: FeedMemberRemovedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.memberId == rhs.memberId &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(memberId)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
