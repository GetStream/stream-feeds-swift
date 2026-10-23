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
    /// Block list name
    public var name: String
    public var team: String?
    /// Block list type. One of: regex, domain, domain_allowlist, email, email_allowlist, word, word_allowlist
    public var type: String
    /// Date/time of the last update
    public var updatedAt: Date?
    /// List of words to block
    public var words: [String]

    public init(createdAt: Date? = nil, id: String? = nil, name: String, team: String? = nil, type: String, updatedAt: Date? = nil, words: [String]) {
        self.createdAt = createdAt
        self.id = id
        self.name = name
        self.team = team
        self.type = type
        self.updatedAt = updatedAt
        self.words = words
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case id
        case name
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
