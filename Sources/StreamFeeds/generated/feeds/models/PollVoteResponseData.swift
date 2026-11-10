//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteResponseData: Sendable, Decodable {
    public let answerText: String?
    public let createdAt: Date
    public let id: String
    public let isAnswer: Bool?
    public let optionId: String
    public let pollId: String
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse?
    public let userId: String?

    public init(answerText: String? = nil, createdAt: Date, id: String, isAnswer: Bool? = nil, optionId: String, pollId: String, updatedAt: Date, user: UserResponse? = nil, userId: String? = nil) {
        self.answerText = answerText
        self.createdAt = createdAt
        self.id = id
        self.isAnswer = isAnswer
        self.optionId = optionId
        self.pollId = pollId
        self.updatedAt = updatedAt
        self.user = user
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.answerText = try container.decodeIfPresent(String.self, forKey: .answerText)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.id = try container.decode(String.self, forKey: .id)
        self.isAnswer = try container.decodeIfPresent(Bool.self, forKey: .isAnswer)
        self.optionId = try container.decode(String.self, forKey: .optionId)
        self.pollId = try container.decode(String.self, forKey: .pollId)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decodeIfPresent(UserResponse.self, forKey: .user)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }
}

extension PollVoteResponseData: Hashable {
    public static func == (lhs: PollVoteResponseData, rhs: PollVoteResponseData) -> Bool {
        lhs.answerText == rhs.answerText &&
            lhs.createdAt == rhs.createdAt &&
            lhs.id == rhs.id &&
            lhs.isAnswer == rhs.isAnswer &&
            lhs.optionId == rhs.optionId &&
            lhs.pollId == rhs.pollId &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(answerText)
        hasher.combine(createdAt)
        hasher.combine(id)
        hasher.combine(isAnswer)
        hasher.combine(optionId)
        hasher.combine(pollId)
        hasher.combine(updatedAt)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
