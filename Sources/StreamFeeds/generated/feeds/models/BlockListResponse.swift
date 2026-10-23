//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Block list contains restricted words
public final class BlockListResponse: Sendable, Codable, JSONEncodable {
    /// Date/time of creation
    public let createdAt: Date?
    public let id: String?
    public let isConfusableFoldingEnabled: Bool
    public let isLeetCheckEnabled: Bool
    public let isPluralCheckEnabled: Bool
    public let isSubstringMatchingEnabled: Bool
    /// Block list name
    public let name: String
    public let ownerUserId: String?
    public let team: String?
    /// Block list type. One of: regex, domain, domain_allowlist, email, email_allowlist, word, word_allowlist
    public let type: String
    /// Date/time of the last update
    public let updatedAt: Date?
    /// List of words to block
    public let words: [String]

    public init(createdAt: Date? = nil, id: String? = nil, isConfusableFoldingEnabled: Bool, isLeetCheckEnabled: Bool, isPluralCheckEnabled: Bool, isSubstringMatchingEnabled: Bool, name: String, ownerUserId: String? = nil, team: String? = nil, type: String, updatedAt: Date? = nil, words: [String]) {
        self.createdAt = createdAt
        self.id = id
        self.isConfusableFoldingEnabled = isConfusableFoldingEnabled
        self.isLeetCheckEnabled = isLeetCheckEnabled
        self.isPluralCheckEnabled = isPluralCheckEnabled
        self.isSubstringMatchingEnabled = isSubstringMatchingEnabled
        self.name = name
        self.ownerUserId = ownerUserId
        self.team = team
        self.type = type
        self.updatedAt = updatedAt
        self.words = words
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.isConfusableFoldingEnabled = try container.decode(Bool.self, forKey: .isConfusableFoldingEnabled)
        self.isLeetCheckEnabled = try container.decode(Bool.self, forKey: .isLeetCheckEnabled)
        self.isPluralCheckEnabled = try container.decode(Bool.self, forKey: .isPluralCheckEnabled)
        self.isSubstringMatchingEnabled = try container.decode(Bool.self, forKey: .isSubstringMatchingEnabled)
        self.name = try container.decode(String.self, forKey: .name)
        self.ownerUserId = try container.decodeIfPresent(String.self, forKey: .ownerUserId)
        self.team = try container.decodeIfPresent(String.self, forKey: .team)
        self.type = try container.decode(String.self, forKey: .type)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.words = try container.decode([String].self, forKey: .words)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(isConfusableFoldingEnabled, forKey: .isConfusableFoldingEnabled)
        try container.encode(isLeetCheckEnabled, forKey: .isLeetCheckEnabled)
        try container.encode(isPluralCheckEnabled, forKey: .isPluralCheckEnabled)
        try container.encode(isSubstringMatchingEnabled, forKey: .isSubstringMatchingEnabled)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(ownerUserId, forKey: .ownerUserId)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encode(words, forKey: .words)
    }
}

extension BlockListResponse: Hashable {
    public static func == (lhs: BlockListResponse, rhs: BlockListResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.id == rhs.id &&
            lhs.isConfusableFoldingEnabled == rhs.isConfusableFoldingEnabled &&
            lhs.isLeetCheckEnabled == rhs.isLeetCheckEnabled &&
            lhs.isPluralCheckEnabled == rhs.isPluralCheckEnabled &&
            lhs.isSubstringMatchingEnabled == rhs.isSubstringMatchingEnabled &&
            lhs.name == rhs.name &&
            lhs.ownerUserId == rhs.ownerUserId &&
            lhs.team == rhs.team &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.words == rhs.words
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(id)
        hasher.combine(isConfusableFoldingEnabled)
        hasher.combine(isLeetCheckEnabled)
        hasher.combine(isPluralCheckEnabled)
        hasher.combine(isSubstringMatchingEnabled)
        hasher.combine(name)
        hasher.combine(ownerUserId)
        hasher.combine(team)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(words)
    }
}
