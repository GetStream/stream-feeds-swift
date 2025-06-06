import Foundation
import StreamCore

public final class PollVoteCastedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var cid: String?
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var messageId: String?
    public var poll: PollResponseData
    public var pollVote: PollVoteResponseData
    public var receivedAt: Date?
    public var type: String = "poll.vote_casted"

    public init(cid: String? = nil, createdAt: Date, custom: [String: RawJSON], messageId: String? = nil, poll: PollResponseData, pollVote: PollVoteResponseData, receivedAt: Date? = nil) {
        self.cid = cid
        self.createdAt = createdAt
        self.custom = custom
        self.messageId = messageId
        self.poll = poll
        self.pollVote = pollVote
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case cid
        case createdAt = "created_at"
        case custom
        case messageId = "message_id"
        case poll
        case pollVote = "poll_vote"
        case receivedAt = "received_at"
        case type
    }

    public static func == (lhs: PollVoteCastedEvent, rhs: PollVoteCastedEvent) -> Bool {
        lhs.cid == rhs.cid &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.messageId == rhs.messageId &&
            lhs.poll == rhs.poll &&
            lhs.pollVote == rhs.pollVote &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(cid)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(messageId)
        hasher.combine(poll)
        hasher.combine(pollVote)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
