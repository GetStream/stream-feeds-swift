//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetFollowSuggestionsResponse: Sendable, Decodable {
    public let duration: String
    /// List of suggested feeds to follow
    public let suggestions: [FeedSuggestionResponse]

    public init(duration: String, suggestions: [FeedSuggestionResponse]) {
        self.duration = duration
        self.suggestions = suggestions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.suggestions = try container.decode([FeedSuggestionResponse].self, forKey: .suggestions)
    }
}

extension GetFollowSuggestionsResponse: Hashable {
    public static func == (lhs: GetFollowSuggestionsResponse, rhs: GetFollowSuggestionsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.suggestions == rhs.suggestions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(suggestions)
    }
}
