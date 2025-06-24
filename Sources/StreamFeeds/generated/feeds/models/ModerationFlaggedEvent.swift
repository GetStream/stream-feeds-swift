import Foundation
import StreamCore

public final class ModerationFlaggedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var item: String?
    public var objectId: String?
    public var type: String = "moderation.flagged"
    public var user: User?

    public init(createdAt: Date, item: String? = nil, objectId: String? = nil, user: User? = nil) {
        self.createdAt = createdAt
        self.item = item
        self.objectId = objectId
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case item
        case objectId = "object_id"
        case type
        case user
    }

    public static func == (lhs: ModerationFlaggedEvent, rhs: ModerationFlaggedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.item == rhs.item &&
            lhs.objectId == rhs.objectId &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(item)
        hasher.combine(objectId)
        hasher.combine(type)
        hasher.combine(user)
    }
}
