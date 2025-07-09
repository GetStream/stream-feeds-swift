//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VoteData: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var answerText: String?
    public var optionId: String?

    public init(answerText: String? = nil, optionId: String? = nil) {
        self.answerText = answerText
        self.optionId = optionId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case answerText = "answer_text"
        case optionId = "option_id"
    }

    public static func == (lhs: VoteData, rhs: VoteData) -> Bool {
        lhs.answerText == rhs.answerText &&
            lhs.optionId == rhs.optionId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(answerText)
        hasher.combine(optionId)
    }
}
