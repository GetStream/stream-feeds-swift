import Foundation
import StreamCore

public final class PollVoteChangedFeedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var poll: PollResponseData
    public var pollVote: PollVoteResponseData
    public var receivedAt: Date?
    public var type: String = "feeds.poll.vote_changed"

    public init(createdAt: Date, custom: [String: RawJSON], fid: String, poll: PollResponseData, pollVote: PollVoteResponseData, receivedAt: Date? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.poll = poll
        self.pollVote = pollVote
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case fid
        case poll
        case pollVote = "poll_vote"
        case receivedAt = "received_at"
        case type
    }

    public static func == (lhs: PollVoteChangedFeedEvent, rhs: PollVoteChangedFeedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.poll == rhs.poll &&
            lhs.pollVote == rhs.pollVote &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(poll)
        hasher.combine(pollVote)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
