//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetFollowSuggestionsResponse: Sendable, Codable, JSONEncodable {
    public let algorithmUsed: String?
    public let duration: String
    /// List of suggested feeds to follow
    public let suggestions: [FeedSuggestionResponse]

    public init(algorithmUsed: String? = nil, duration: String, suggestions: [FeedSuggestionResponse]) {
        self.algorithmUsed = algorithmUsed
        self.duration = duration
        self.suggestions = suggestions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.algorithmUsed = try container.decodeIfPresent(String.self, forKey: .algorithmUsed)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.suggestions = try container.decode([FeedSuggestionResponse].self, forKey: .suggestions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(algorithmUsed, forKey: .algorithmUsed)
        try container.encode(duration, forKey: .duration)
        try container.encode(suggestions, forKey: .suggestions)
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
