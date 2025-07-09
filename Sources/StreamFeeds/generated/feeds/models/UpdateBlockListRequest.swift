//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBlockListRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var team: String?
    public var words: [String]?

    public init(team: String? = nil, words: [String]? = nil) {
        self.team = team
        self.words = words
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case team
        case words
    }

    public static func == (lhs: UpdateBlockListRequest, rhs: UpdateBlockListRequest) -> Bool {
        lhs.team == rhs.team &&
            lhs.words == rhs.words
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(team)
        hasher.combine(words)
    }
}
