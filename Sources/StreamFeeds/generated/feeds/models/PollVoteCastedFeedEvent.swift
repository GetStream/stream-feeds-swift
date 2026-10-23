//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteCastedFeedEvent: Sendable, Event, Codable, JSONEncodable {
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let feedVisibility: String?
    public let fid: String
    public let poll: PollResponseData
    public let pollVote: PollVoteResponseData
    public let receivedAt: Date?
    public let type: String

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, poll: PollResponseData, pollVote: PollVoteResponseData, receivedAt: Date? = nil, type: String = "feeds.poll.vote_casted") {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.poll = poll
        self.pollVote = pollVote
        self.receivedAt = receivedAt
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(String.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.poll = try container.decode(PollResponseData.self, forKey: .poll)
        self.pollVote = try container.decode(PollVoteResponseData.self, forKey: .pollVote)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(feedVisibility, forKey: .feedVisibility)
        try container.encode(fid, forKey: .fid)
        try container.encode(poll, forKey: .poll)
        try container.encode(pollVote, forKey: .pollVote)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encode(type, forKey: .type)
    }
}

extension PollVoteCastedFeedEvent: Hashable {
    public static func == (lhs: PollVoteCastedFeedEvent, rhs: PollVoteCastedFeedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.poll == rhs.poll &&
            lhs.pollVote == rhs.pollVote &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(poll)
        hasher.combine(pollVote)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
