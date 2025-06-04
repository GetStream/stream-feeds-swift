import Foundation
import StreamCore

public final class VoteData: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var answerText: String?
    public var option: PollOptionResponseData?
    public var optionId: String?

    public init(answerText: String? = nil, option: PollOptionResponseData? = nil, optionId: String? = nil) {
        self.answerText = answerText
        self.option = option
        self.optionId = optionId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case answerText = "answer_text"
        case option = "Option"
        case optionId = "option_id"
    }

    public static func == (lhs: VoteData, rhs: VoteData) -> Bool {
        lhs.answerText == rhs.answerText &&
            lhs.option == rhs.option &&
            lhs.optionId == rhs.optionId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(answerText)
        hasher.combine(option)
        hasher.combine(optionId)
    }
}
