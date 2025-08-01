//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetFollowSuggestionsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var suggestions: [FeedResponse]

    public init(duration: String, suggestions: [FeedResponse]) {
        self.duration = duration
        self.suggestions = suggestions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case suggestions
    }

    public static func == (lhs: GetFollowSuggestionsResponse, rhs: GetFollowSuggestionsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.suggestions == rhs.suggestions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(suggestions)
    }
}
