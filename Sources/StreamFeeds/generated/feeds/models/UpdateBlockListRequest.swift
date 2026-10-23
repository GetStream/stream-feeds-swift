//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBlockListRequest: @unchecked Sendable, Codable, JSONEncodable {
    public var isConfusableFoldingEnabled: Bool?
    public var isLeetCheckEnabled: Bool?
    public var isPluralCheckEnabled: Bool?
    public var isSubstringMatchingEnabled: Bool?
    public var team: String?
    /// List of words to block
    public var words: [String]?

    public init(isConfusableFoldingEnabled: Bool? = nil, isLeetCheckEnabled: Bool? = nil, isPluralCheckEnabled: Bool? = nil, isSubstringMatchingEnabled: Bool? = nil, team: String? = nil, words: [String]? = nil) {
        self.isConfusableFoldingEnabled = isConfusableFoldingEnabled
        self.isLeetCheckEnabled = isLeetCheckEnabled
        self.isPluralCheckEnabled = isPluralCheckEnabled
        self.isSubstringMatchingEnabled = isSubstringMatchingEnabled
        self.team = team
        self.words = words
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case isConfusableFoldingEnabled = "is_confusable_folding_enabled"
        case isLeetCheckEnabled = "is_leet_check_enabled"
        case isPluralCheckEnabled = "is_plural_check_enabled"
        case isSubstringMatchingEnabled = "is_substring_matching_enabled"
        case team
        case words
    }
}

extension UpdateBlockListRequest: Hashable {
    public static func == (lhs: UpdateBlockListRequest, rhs: UpdateBlockListRequest) -> Bool {
        lhs.isConfusableFoldingEnabled == rhs.isConfusableFoldingEnabled &&
            lhs.isLeetCheckEnabled == rhs.isLeetCheckEnabled &&
            lhs.isPluralCheckEnabled == rhs.isPluralCheckEnabled &&
            lhs.isSubstringMatchingEnabled == rhs.isSubstringMatchingEnabled &&
            lhs.team == rhs.team &&
            lhs.words == rhs.words
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(isConfusableFoldingEnabled)
        hasher.combine(isLeetCheckEnabled)
        hasher.combine(isPluralCheckEnabled)
        hasher.combine(isSubstringMatchingEnabled)
        hasher.combine(team)
        hasher.combine(words)
    }
}
