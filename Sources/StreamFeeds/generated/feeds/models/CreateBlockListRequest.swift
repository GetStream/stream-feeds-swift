//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CreateBlockListRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum CreateBlockListRequestType: String, Sendable, Codable, CaseIterable {
        case domain
        case domainAllowlist = "domain_allowlist"
        case email
        case regex
        case word
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

    public var name: String
    public var team: String?
    public var type: CreateBlockListRequestType?
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
