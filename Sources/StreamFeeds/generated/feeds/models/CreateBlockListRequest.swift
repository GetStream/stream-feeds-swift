//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Block list contains restricted words
public final class CreateBlockListRequest: @unchecked Sendable, Codable, JSONEncodable {
    public enum CreateBlockListRequestType: String, Sendable, Codable, CaseIterable {
        case domain
        case domainAllowlist = "domain_allowlist"
        case email
        case emailAllowlist = "email_allowlist"
        case regex
        case word
        case wordAllowlist = "word_allowlist"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// Block list name
    public var name: String
    public var team: String?
    /// Block list type. One of: regex, domain, domain_allowlist, email, email_allowlist, word, word_allowlist
    public var type: CreateBlockListRequestType?
    /// List of words to block
    public var words: [String]

    public init(name: String, team: String? = nil, words: [String]) {
        self.name = name
        self.team = team
        self.words = words
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case team
        case type
        case words
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
