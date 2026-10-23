//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetFollowSuggestionsResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var algorithmUsed: String?
    public var duration: String
    /// List of suggested feeds to follow
    public var suggestions: [FeedSuggestionResponse]

    public init(
        algorithmUsed: String? = nil,
        duration: String,
        suggestions: [FeedSuggestionResponse]
    ) {
        self.algorithmUsed = algorithmUsed
        self.duration = duration
        self.suggestions = suggestions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case algorithmUsed = "algorithm_used"
        case duration
        case suggestions
    }
}

extension GetFollowSuggestionsResponse: Hashable {
    public static func == (lhs: GetFollowSuggestionsResponse, rhs: GetFollowSuggestionsResponse) -> Bool {
        lhs.algorithmUsed == rhs.algorithmUsed &&
            lhs.duration == rhs.duration &&
            lhs.suggestions == rhs.suggestions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(algorithmUsed)
        hasher.combine(duration)
        hasher.combine(suggestions)
    }
}
