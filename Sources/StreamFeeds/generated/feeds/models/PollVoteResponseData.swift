//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteResponseData: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var answerText: String?
    public var createdAt: Date
    public var id: String
    public var isAnswer: Bool?
    public var optionId: String
    public var pollId: String
    public var updatedAt: Date
    public var user: UserResponse?
    public var userId: String?

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case answerText = "answer_text"
        case createdAt = "created_at"
        case id
        case isAnswer = "is_answer"
        case optionId = "option_id"
        case pollId = "poll_id"
        case updatedAt = "updated_at"
        case user
        case userId = "user_id"
    }

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
