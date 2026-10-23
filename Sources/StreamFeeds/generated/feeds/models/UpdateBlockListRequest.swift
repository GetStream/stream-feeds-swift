//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBlockListRequest: Sendable, Codable, JSONEncodable {
    public let isConfusableFoldingEnabled: Bool?
    public let isLeetCheckEnabled: Bool?
    public let isPluralCheckEnabled: Bool?
    public let isSubstringMatchingEnabled: Bool?
    public let team: String?
    /// List of words to block
    public let words: [String]?

    public init(isConfusableFoldingEnabled: Bool? = nil, isLeetCheckEnabled: Bool? = nil, isPluralCheckEnabled: Bool? = nil, isSubstringMatchingEnabled: Bool? = nil, team: String? = nil, words: [String]? = nil) {
        self.isConfusableFoldingEnabled = isConfusableFoldingEnabled
        self.isLeetCheckEnabled = isLeetCheckEnabled
        self.isPluralCheckEnabled = isPluralCheckEnabled
        self.isSubstringMatchingEnabled = isSubstringMatchingEnabled
        self.team = team
        self.words = words
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.isConfusableFoldingEnabled = try container.decodeIfPresent(Bool.self, forKey: .isConfusableFoldingEnabled)
        self.isLeetCheckEnabled = try container.decodeIfPresent(Bool.self, forKey: .isLeetCheckEnabled)
        self.isPluralCheckEnabled = try container.decodeIfPresent(Bool.self, forKey: .isPluralCheckEnabled)
        self.isSubstringMatchingEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSubstringMatchingEnabled)
        self.team = try container.decodeIfPresent(String.self, forKey: .team)
        self.words = try container.decodeIfPresent([String].self, forKey: .words)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(isConfusableFoldingEnabled, forKey: .isConfusableFoldingEnabled)
        try container.encodeIfPresent(isLeetCheckEnabled, forKey: .isLeetCheckEnabled)
        try container.encodeIfPresent(isPluralCheckEnabled, forKey: .isPluralCheckEnabled)
        try container.encodeIfPresent(isSubstringMatchingEnabled, forKey: .isSubstringMatchingEnabled)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encodeIfPresent(words, forKey: .words)
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
