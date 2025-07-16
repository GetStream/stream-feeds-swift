//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollVoteData: Identifiable, Equatable, Sendable {
    public let answerText: String?
    public let createdAt: Date
    public let id: String
    public let isAnswer: Bool?
    public let optionId: String
    public let pollId: String
    public let updatedAt: Date
    public let user: UserData?
    public let userId: String?
}

// MARK: - Model Conversions

extension PollVoteResponseData {
    func toModel() -> PollVoteData {
        PollVoteData(
            answerText: answerText,
            createdAt: createdAt,
            id: id,
            isAnswer: isAnswer,
            optionId: optionId,
            pollId: pollId,
            updatedAt: updatedAt,
            user: user?.toModel(),
            userId: userId
        )
    }
}
