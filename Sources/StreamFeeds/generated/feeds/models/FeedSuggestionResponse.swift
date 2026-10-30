//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedSuggestionResponse: Sendable, Decodable {
    public let feed: FeedResponse
    public let algorithmScores: [String: Double]?
    public let reason: String?
    public let recommendationScore: Double?

    public init(feed: FeedResponse, algorithmScores: [String: Double]? = nil, reason: String? = nil, recommendationScore: Double? = nil) {
        self.feed = feed
        self.algorithmScores = algorithmScores
        self.reason = reason
        self.recommendationScore = recommendationScore
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.feed = try FeedResponse(from: decoder)
        self.algorithmScores = try container.decodeIfPresent([String: Double].self, forKey: .algorithmScores)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.recommendationScore = try container.decodeIfPresent(Double.self, forKey: .recommendationScore)
    }
}

extension FeedSuggestionResponse: Hashable {
    public static func == (lhs: FeedSuggestionResponse, rhs: FeedSuggestionResponse) -> Bool {
        lhs.feed == rhs.feed &&
            lhs.algorithmScores == rhs.algorithmScores &&
            lhs.reason == rhs.reason &&
            lhs.recommendationScore == rhs.recommendationScore
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feed)
        hasher.combine(algorithmScores)
        hasher.combine(reason)
        hasher.combine(recommendationScore)
    }
}
