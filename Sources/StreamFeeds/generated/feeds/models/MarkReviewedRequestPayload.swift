//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for mark reviewed action
public final class MarkReviewedRequestPayload: Sendable, Codable, JSONEncodable {
    /// Maximum content items to mark as reviewed
    public let contentToMarkAsReviewedLimit: Int?
    /// Reason for the appeal decision
    public let decisionReason: String?
    /// Skip marking content as reviewed
    public let disableMarkingContentAsReviewed: Bool?

    public init(contentToMarkAsReviewedLimit: Int? = nil, decisionReason: String? = nil, disableMarkingContentAsReviewed: Bool? = nil) {
        self.contentToMarkAsReviewedLimit = contentToMarkAsReviewedLimit
        self.decisionReason = decisionReason
        self.disableMarkingContentAsReviewed = disableMarkingContentAsReviewed
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.contentToMarkAsReviewedLimit = try container.decodeIfPresent(Int.self, forKey: .contentToMarkAsReviewedLimit)
        self.decisionReason = try container.decodeIfPresent(String.self, forKey: .decisionReason)
        self.disableMarkingContentAsReviewed = try container.decodeIfPresent(Bool.self, forKey: .disableMarkingContentAsReviewed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(contentToMarkAsReviewedLimit, forKey: .contentToMarkAsReviewedLimit)
        try container.encodeIfPresent(decisionReason, forKey: .decisionReason)
        try container.encodeIfPresent(disableMarkingContentAsReviewed, forKey: .disableMarkingContentAsReviewed)
    }
}

extension MarkReviewedRequestPayload: Hashable {
    public static func == (lhs: MarkReviewedRequestPayload, rhs: MarkReviewedRequestPayload) -> Bool {
        lhs.contentToMarkAsReviewedLimit == rhs.contentToMarkAsReviewedLimit &&
            lhs.decisionReason == rhs.decisionReason &&
            lhs.disableMarkingContentAsReviewed == rhs.disableMarkingContentAsReviewed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentToMarkAsReviewedLimit)
        hasher.combine(decisionReason)
        hasher.combine(disableMarkingContentAsReviewed)
    }
}
