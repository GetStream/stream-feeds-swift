//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for mark reviewed action
public final class MarkReviewedRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Maximum content items to mark as reviewed
    public var contentToMarkAsReviewedLimit: Int?
    /// Reason for the appeal decision
    public var decisionReason: String?
    /// Skip marking content as reviewed
    public var disableMarkingContentAsReviewed: Bool?

    public init(contentToMarkAsReviewedLimit: Int? = nil, decisionReason: String? = nil, disableMarkingContentAsReviewed: Bool? = nil) {
        self.contentToMarkAsReviewedLimit = contentToMarkAsReviewedLimit
        self.decisionReason = decisionReason
        self.disableMarkingContentAsReviewed = disableMarkingContentAsReviewed
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case contentToMarkAsReviewedLimit = "content_to_mark_as_reviewed_limit"
        case decisionReason = "decision_reason"
        case disableMarkingContentAsReviewed = "disable_marking_content_as_reviewed"
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
