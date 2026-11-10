//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollOptionData: Identifiable, Equatable, Sendable {
    public let custom: [String: RawJSON]
    public let id: String
    /// The language code of the original ``text``.
    public let originalLanguage: String?
    public let text: String
    /// Automatic translations of ``text``, keyed by language code.
    ///
    /// - Note: Feeds doesn't translate polls automatically.
    public let translations: [String: String]?
}

// MARK: - Translations

extension PollOptionData {
    /// The translation of ``text`` to the given language code, or `nil` when there is none, or it is the same as the original text.
    public func translatedText(for language: String) -> String? {
        I18n.validTranslation(of: text, in: translations, for: language, originalLanguage: originalLanguage)
    }
}

// MARK: - Model Conversions

extension PollOptionResponseData {
    func toModel() -> PollOptionData {
        PollOptionData(
            custom: custom,
            id: id,
            originalLanguage: I18n.originalLanguage(from: textI18n),
            text: text,
            translations: I18n.translations(from: textI18n)
        )
    }
}
