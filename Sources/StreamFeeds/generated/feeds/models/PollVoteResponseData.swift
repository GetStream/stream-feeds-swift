//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteResponseData: Sendable, Codable, JSONEncodable {
    public let answerText: String?
    public let answerTextI18n: [String: String]?
    public let createdAt: Date
    public let id: String
    public let isAnswer: Bool?
    public let optionId: String
    public let pollId: String
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse?
    public let userId: String?

    public init(answerText: String? = nil, answerTextI18n: [String: String]? = nil, createdAt: Date, id: String, isAnswer: Bool? = nil, optionId: String, pollId: String, updatedAt: Date, user: UserResponse? = nil, userId: String? = nil) {
        self.answerText = answerText
        self.answerTextI18n = answerTextI18n
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
        self.answerTextI18n = try container.decodeIfPresent([String: String].self, forKey: .answerTextI18n)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.id = try container.decode(String.self, forKey: .id)
        self.isAnswer = try container.decodeIfPresent(Bool.self, forKey: .isAnswer)
        self.optionId = try container.decode(String.self, forKey: .optionId)
        self.pollId = try container.decode(String.self, forKey: .pollId)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decodeIfPresent(UserResponse.self, forKey: .user)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(answerText, forKey: .answerText)
        try container.encodeIfPresent(answerTextI18n, forKey: .answerTextI18n)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(isAnswer, forKey: .isAnswer)
        try container.encode(optionId, forKey: .optionId)
        try container.encode(pollId, forKey: .pollId)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(userId, forKey: .userId)
    }
}

extension PollVoteResponseData: Hashable {
    public static func == (lhs: PollVoteResponseData, rhs: PollVoteResponseData) -> Bool {
        lhs.answerText == rhs.answerText &&
            lhs.answerTextI18n == rhs.answerTextI18n &&
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
        hasher.combine(answerTextI18n)
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
