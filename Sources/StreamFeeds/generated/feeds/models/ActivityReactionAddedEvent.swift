import Foundation
import StreamCore

public final class ActivityReactionAddedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var reaction: ActivityReaction
    public var receivedAt: Date?
    public var type: String = "activity.reaction.added"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], fid: String, reaction: ActivityReaction, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.reaction = reaction
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case fid
        case reaction
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: ActivityReactionAddedEvent, rhs: ActivityReactionAddedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.reaction == rhs.reaction &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(reaction)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
