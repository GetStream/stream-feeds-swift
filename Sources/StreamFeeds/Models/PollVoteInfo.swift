//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollVoteInfo: Identifiable, Sendable {
    public let answerText: String?
    public let createdAt: Date
    public let id: String
    public let isAnswer: Bool?
    public let optionId: String
    public let pollId: String
    public let updatedAt: Date
    public let user: UserInfo?
    public let userId: String?
    
    init(from response: PollVoteResponseData) {
        self.answerText = response.answerText
        self.createdAt = response.createdAt
        self.id = response.id
        self.isAnswer = response.isAnswer
        self.optionId = response.optionId
        self.pollId = response.pollId
        self.updatedAt = response.updatedAt
        self.user = response.user.flatMap(UserInfo.init(from:))
        self.userId = response.userId
    }
} 
