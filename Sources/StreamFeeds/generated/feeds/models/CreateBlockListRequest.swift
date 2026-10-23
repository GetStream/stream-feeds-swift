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
public final class CreateBlockListRequest: Sendable, Encodable, JSONEncodable {
    /// Block list name
    public let name: String
    public let team: String?
    /// Block list type. One of: regex, domain, domain_allowlist, email, email_allowlist, word, word_allowlist
    public let type: CreateBlockListRequestType?
    /// List of words to block
    public let words: [String]

    public init(name: String, team: String? = nil, type: CreateBlockListRequestType? = nil, words: [String]) {
        self.name = name
        self.team = team
        self.type = type
        self.words = words
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encode(words, forKey: .words)
    }
}

extension CreateBlockListRequest: Hashable {
    public static func == (lhs: CreateBlockListRequest, rhs: CreateBlockListRequest) -> Bool {
        lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.type == rhs.type &&
            lhs.words == rhs.words
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(team)
        hasher.combine(type)
        hasher.combine(words)
    }
}
