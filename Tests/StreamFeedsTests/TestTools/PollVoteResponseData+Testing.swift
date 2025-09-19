//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollVoteResponseData {
    static func dummy(
        answerText: String? = nil,
        createdAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
        id: String = "vote-123",
        isAnswer: Bool = false,
        optionId: String = "option-1",
        pollId: String = "poll-123",
        updatedAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
        user: UserResponse? = UserResponse.dummy()
    ) -> PollVoteResponseData {
        PollVoteResponseData(
            answerText: answerText,
            createdAt: createdAt,
            id: id,
            isAnswer: isAnswer,
            optionId: optionId,
            pollId: pollId,
            updatedAt: updatedAt,
            user: user,
            userId: user?.id ?? ""
        )
    }
}
