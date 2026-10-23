//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for mark reviewed action
public final class MarkReviewedRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Maximum content items to mark as reviewed
    public var contentToMarkAsReviewedLimit: Int?
    /// Skip marking content as reviewed
    public var disableMarkingContentAsReviewed: Bool?

    public init(contentToMarkAsReviewedLimit: Int? = nil, disableMarkingContentAsReviewed: Bool? = nil) {
        self.contentToMarkAsReviewedLimit = contentToMarkAsReviewedLimit
        self.disableMarkingContentAsReviewed = disableMarkingContentAsReviewed
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case contentToMarkAsReviewedLimit = "content_to_mark_as_reviewed_limit"
        case disableMarkingContentAsReviewed = "disable_marking_content_as_reviewed"
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
