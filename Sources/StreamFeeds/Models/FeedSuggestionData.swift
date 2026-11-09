//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A feed suggested for the current user to follow.
public struct FeedSuggestionData: Identifiable, Equatable, Sendable {
    /// Scores from the algorithms that suggested the feed, keyed by algorithm.
    public let algorithmScores: [String: Double]?
    /// The suggested feed.
    public let feed: FeedData
    /// The reason the feed is suggested.
    public let reason: String?
    /// The overall recommendation score.
    public let recommendationScore: Double?

    public var id: String { feed.id }
}

// MARK: - Model Conversions

extension FeedSuggestionResponse {
    func toModel() -> FeedSuggestionData {
        FeedSuggestionData(
            algorithmScores: algorithmScores,
            feed: feed.toModel(),
            reason: reason,
            recommendationScore: recommendationScore
        )
    }
}
