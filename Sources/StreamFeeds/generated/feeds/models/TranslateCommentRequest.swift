//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class TranslateCommentRequest: Sendable, Encodable, JSONEncodable {
    /// ISO 639-1 language code to translate to
    public let language: String

    public init(language: String) {
        self.language = language
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(language, forKey: .language)
    }
}

extension TranslateCommentRequest: Hashable {
    public static func == (lhs: TranslateCommentRequest, rhs: TranslateCommentRequest) -> Bool {
        lhs.language == rhs.language
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(language)
    }
}
