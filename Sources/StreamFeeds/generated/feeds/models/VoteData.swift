//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VoteData: Sendable, Codable, JSONEncodable {
    public let answerText: String?
    public let optionId: String?

    public init(answerText: String? = nil, optionId: String? = nil) {
        self.answerText = answerText
        self.optionId = optionId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.answerText = try container.decodeIfPresent(String.self, forKey: .answerText)
        self.optionId = try container.decodeIfPresent(String.self, forKey: .optionId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(answerText, forKey: .answerText)
        try container.encodeIfPresent(optionId, forKey: .optionId)
    }
}

extension VoteData: Hashable {
    public static func == (lhs: VoteData, rhs: VoteData) -> Bool {
        lhs.answerText == rhs.answerText &&
            lhs.optionId == rhs.optionId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(answerText)
        hasher.combine(optionId)
    }
}
