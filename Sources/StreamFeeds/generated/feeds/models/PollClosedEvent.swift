import Foundation
import StreamCore

public final class PollClosedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var activityId: String?
    public var cid: String?
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var messageId: String?
    public var poll: PollResponseData
    public var receivedAt: Date?
    public var type: String = "poll.closed"

    public init(activityId: String? = nil, cid: String? = nil, createdAt: Date, custom: [String: RawJSON], messageId: String? = nil, poll: PollResponseData, receivedAt: Date? = nil) {
        self.activityId = activityId
        self.cid = cid
        self.createdAt = createdAt
        self.custom = custom
        self.messageId = messageId
        self.poll = poll
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case cid
        case createdAt = "created_at"
        case custom
        case messageId = "message_id"
        case poll
        case receivedAt = "received_at"
        case type
    }

    public static func == (lhs: PollClosedEvent, rhs: PollClosedEvent) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.cid == rhs.cid &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.messageId == rhs.messageId &&
            lhs.poll == rhs.poll &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(cid)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(messageId)
        hasher.combine(poll)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
