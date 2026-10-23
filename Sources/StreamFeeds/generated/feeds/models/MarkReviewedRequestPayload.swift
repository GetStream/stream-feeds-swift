//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for mark reviewed action
public final class MarkReviewedRequestPayload: Sendable, Codable, JSONEncodable {
    /// Maximum content items to mark as reviewed
    public let contentToMarkAsReviewedLimit: Int?
    /// Skip marking content as reviewed
    public let disableMarkingContentAsReviewed: Bool?

    public init(contentToMarkAsReviewedLimit: Int? = nil, disableMarkingContentAsReviewed: Bool? = nil) {
        self.contentToMarkAsReviewedLimit = contentToMarkAsReviewedLimit
        self.disableMarkingContentAsReviewed = disableMarkingContentAsReviewed
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.contentToMarkAsReviewedLimit = try container.decodeIfPresent(Int.self, forKey: .contentToMarkAsReviewedLimit)
        self.disableMarkingContentAsReviewed = try container.decodeIfPresent(Bool.self, forKey: .disableMarkingContentAsReviewed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(contentToMarkAsReviewedLimit, forKey: .contentToMarkAsReviewedLimit)
        try container.encodeIfPresent(disableMarkingContentAsReviewed, forKey: .disableMarkingContentAsReviewed)
    }
}

extension MarkReviewedRequestPayload: Hashable {
    public static func == (lhs: MarkReviewedRequestPayload, rhs: MarkReviewedRequestPayload) -> Bool {
        lhs.contentToMarkAsReviewedLimit == rhs.contentToMarkAsReviewedLimit &&
            lhs.disableMarkingContentAsReviewed == rhs.disableMarkingContentAsReviewed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentToMarkAsReviewedLimit)
        hasher.combine(disableMarkingContentAsReviewed)
    }
}
