//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Block list contains restricted words
public final class BlockListResponse: Sendable, Decodable {
    /// Date/time of creation
    public let createdAt: Date?
    public let id: String?
    /// Block list name
    public let name: String
    public let team: String?
    /// Block list type. One of: regex, domain, domain_allowlist, email, email_allowlist, word, word_allowlist
    public let type: String
    /// Date/time of the last update
    public let updatedAt: Date?
    /// List of words to block
    public let words: [String]

    public init(createdAt: Date? = nil, id: String? = nil, name: String, team: String? = nil, type: String, updatedAt: Date? = nil, words: [String]) {
        self.createdAt = createdAt
        self.id = id
        self.name = name
        self.team = team
        self.type = type
        self.updatedAt = updatedAt
        self.words = words
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.team = try container.decodeIfPresent(String.self, forKey: .team)
        self.type = try container.decode(String.self, forKey: .type)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.words = try container.decode([String].self, forKey: .words)
    }
}

extension BlockListResponse: Hashable {
    public static func == (lhs: BlockListResponse, rhs: BlockListResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.words == rhs.words
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(team)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(words)
    }
}
