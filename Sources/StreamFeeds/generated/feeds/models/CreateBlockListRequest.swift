//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateBlockListRequestType: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let domain = CreateBlockListRequestType(rawValue: "domain")
    public static let domainAllowlist = CreateBlockListRequestType(rawValue: "domain_allowlist")
    public static let email = CreateBlockListRequestType(rawValue: "email")
    public static let emailAllowlist = CreateBlockListRequestType(rawValue: "email_allowlist")
    public static let regex = CreateBlockListRequestType(rawValue: "regex")
    public static let word = CreateBlockListRequestType(rawValue: "word")
    public static let wordAllowlist = CreateBlockListRequestType(rawValue: "word_allowlist")
}

/// Block list contains restricted words
public final class CreateBlockListRequest: Sendable, Codable, JSONEncodable {
    public let isConfusableFoldingEnabled: Bool?
    public let isLeetCheckEnabled: Bool?
    public let isPluralCheckEnabled: Bool?
    public let isSubstringMatchingEnabled: Bool?
    /// Block list name
    public let name: String
    public let team: String?
    /// Block list type. One of: regex, domain, domain_allowlist, email, email_allowlist, word, word_allowlist
    public let type: CreateBlockListRequestType?
    /// List of words to block
    public let words: [String]

    public init(isConfusableFoldingEnabled: Bool? = nil, isLeetCheckEnabled: Bool? = nil, isPluralCheckEnabled: Bool? = nil, isSubstringMatchingEnabled: Bool? = nil, name: String, team: String? = nil, type: CreateBlockListRequestType? = nil, words: [String]) {
        self.isConfusableFoldingEnabled = isConfusableFoldingEnabled
        self.isLeetCheckEnabled = isLeetCheckEnabled
        self.isPluralCheckEnabled = isPluralCheckEnabled
        self.isSubstringMatchingEnabled = isSubstringMatchingEnabled
        self.name = name
        self.team = team
        self.type = type
        self.words = words
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.isConfusableFoldingEnabled = try container.decodeIfPresent(Bool.self, forKey: .isConfusableFoldingEnabled)
        self.isLeetCheckEnabled = try container.decodeIfPresent(Bool.self, forKey: .isLeetCheckEnabled)
        self.isPluralCheckEnabled = try container.decodeIfPresent(Bool.self, forKey: .isPluralCheckEnabled)
        self.isSubstringMatchingEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSubstringMatchingEnabled)
        self.name = try container.decode(String.self, forKey: .name)
        self.team = try container.decodeIfPresent(String.self, forKey: .team)
        self.type = try container.decodeIfPresent(CreateBlockListRequestType.self, forKey: .type)
        self.words = try container.decode([String].self, forKey: .words)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(isConfusableFoldingEnabled, forKey: .isConfusableFoldingEnabled)
        try container.encodeIfPresent(isLeetCheckEnabled, forKey: .isLeetCheckEnabled)
        try container.encodeIfPresent(isPluralCheckEnabled, forKey: .isPluralCheckEnabled)
        try container.encodeIfPresent(isSubstringMatchingEnabled, forKey: .isSubstringMatchingEnabled)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encode(words, forKey: .words)
    }
}

extension CreateBlockListRequest: Hashable {
    public static func == (lhs: CreateBlockListRequest, rhs: CreateBlockListRequest) -> Bool {
        lhs.isConfusableFoldingEnabled == rhs.isConfusableFoldingEnabled &&
            lhs.isLeetCheckEnabled == rhs.isLeetCheckEnabled &&
            lhs.isPluralCheckEnabled == rhs.isPluralCheckEnabled &&
            lhs.isSubstringMatchingEnabled == rhs.isSubstringMatchingEnabled &&
            lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.type == rhs.type &&
            lhs.words == rhs.words
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(isConfusableFoldingEnabled)
        hasher.combine(isLeetCheckEnabled)
        hasher.combine(isPluralCheckEnabled)
        hasher.combine(isSubstringMatchingEnabled)
        hasher.combine(name)
        hasher.combine(team)
        hasher.combine(type)
        hasher.combine(words)
    }
}
