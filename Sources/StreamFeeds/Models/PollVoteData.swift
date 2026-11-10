//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollVoteData: Identifiable, Equatable, Sendable {
    public let answerText: String?
    /// Automatic translations of ``answerText``, keyed by language code.
    ///
    /// - Note: Feeds doesn't translate polls automatically.
    public let answerTextTranslations: [String: String]?
    public let createdAt: Date
    public let id: String
    public let isAnswer: Bool?
    public let optionId: String
    /// The language code of the original ``answerText``.
    public let originalLanguage: String?
    public let pollId: String
    public let updatedAt: Date
    public let user: UserData?
    public let userId: String?
}

// MARK: - Translations

extension PollVoteData {
    /// The translation of ``answerText`` to the given language code, or `nil` when there is none, or it is the same as the original answer.
    public func translatedAnswerText(for language: String) -> String? {
        I18n.validTranslation(of: answerText, in: answerTextTranslations, for: language, originalLanguage: originalLanguage)
    }
}

// MARK: - Model Conversions

extension PollVoteResponseData {
    func toModel() -> PollVoteData {
        PollVoteData(
            answerText: answerText,
            answerTextTranslations: I18n.translations(from: answerTextI18n),
            createdAt: createdAt,
            id: id,
            isAnswer: isAnswer,
            optionId: optionId,
            originalLanguage: I18n.originalLanguage(from: answerTextI18n),
            pollId: pollId,
            updatedAt: updatedAt,
            user: user?.toModel(),
            userId: userId
        )
    }
}
