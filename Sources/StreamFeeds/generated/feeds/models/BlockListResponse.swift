//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Block list contains restricted words
public final class BlockListResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date?
    public var id: String?
    public var isConfusableFoldingEnabled: Bool
    public var isLeetCheckEnabled: Bool
    public var isPluralCheckEnabled: Bool
    public var isSubstringMatchingEnabled: Bool
    /// Block list name
    public var name: String
    public var ownerUserId: String?
    public var team: String?
    /// Block list type. One of: regex, domain, domain_allowlist, email, email_allowlist, word, word_allowlist
    public var type: String
    /// Date/time of the last update
    public var updatedAt: Date?
    /// List of words to block
    public var words: [String]

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case id
        case isConfusableFoldingEnabled = "is_confusable_folding_enabled"
        case isLeetCheckEnabled = "is_leet_check_enabled"
        case isPluralCheckEnabled = "is_plural_check_enabled"
        case isSubstringMatchingEnabled = "is_substring_matching_enabled"
        case name
        case ownerUserId = "owner_user_id"
        case team
        case type
        case updatedAt = "updated_at"
        case words
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
