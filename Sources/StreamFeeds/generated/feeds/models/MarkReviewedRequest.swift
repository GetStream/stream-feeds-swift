import Foundation
import StreamCore

public final class MarkReviewedRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var contentToMarkAsReviewedLimit: Int?
    public var disableMarkingContentAsReviewed: Bool?

    public init(contentToMarkAsReviewedLimit: Int? = nil, disableMarkingContentAsReviewed: Bool? = nil) {
        self.contentToMarkAsReviewedLimit = contentToMarkAsReviewedLimit
        self.disableMarkingContentAsReviewed = disableMarkingContentAsReviewed
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case contentToMarkAsReviewedLimit = "content_to_mark_as_reviewed_limit"
        case disableMarkingContentAsReviewed = "disable_marking_content_as_reviewed"
    }

    public static func == (lhs: MarkReviewedRequest, rhs: MarkReviewedRequest) -> Bool {
        lhs.contentToMarkAsReviewedLimit == rhs.contentToMarkAsReviewedLimit &&
            lhs.disableMarkingContentAsReviewed == rhs.disableMarkingContentAsReviewed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(contentToMarkAsReviewedLimit)
        hasher.combine(disableMarkingContentAsReviewed)
    }
}
