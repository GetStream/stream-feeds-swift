//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBlockListRequest: Sendable, Codable, JSONEncodable {
    public let team: String?
    /// List of words to block
    public let words: [String]?

    public init(team: String? = nil, words: [String]? = nil) {
        self.team = team
        self.words = words
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.team = try container.decodeIfPresent(String.self, forKey: .team)
        self.words = try container.decodeIfPresent([String].self, forKey: .words)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encodeIfPresent(words, forKey: .words)
    }
}

extension UpdateBlockListRequest: Hashable {
    public static func == (lhs: UpdateBlockListRequest, rhs: UpdateBlockListRequest) -> Bool {
        lhs.team == rhs.team &&
            lhs.words == rhs.words
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(team)
        hasher.combine(words)
    }
}
