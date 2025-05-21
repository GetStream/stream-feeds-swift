import Foundation
import StreamCore

public final class UpdateActivityRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var attachments: [Attachment]?
    public var custom: [String: RawJSON]?
    public var expiresAt: Date?
    public var filterTags: [String]?
    public var interestTags: [String]?
    public var location: ActivityLocation?
    public var text: String?
    public var visibility: String?

    public init(attachments: [Attachment]? = nil, custom: [String: RawJSON]? = nil, expiresAt: Date? = nil, filterTags: [String]? = nil, interestTags: [String]? = nil, location: ActivityLocation? = nil, text: String? = nil, visibility: String? = nil) {
        self.attachments = attachments
        self.custom = custom
        self.expiresAt = expiresAt
        self.filterTags = filterTags
        self.interestTags = interestTags
        self.location = location
        self.text = text
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case custom
        case expiresAt = "expires_at"
        case filterTags = "filter_tags"
        case interestTags = "interest_tags"
        case location
        case text
        case visibility
    }

    public static func == (lhs: UpdateActivityRequest, rhs: UpdateActivityRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.custom == rhs.custom &&
            lhs.expiresAt == rhs.expiresAt &&
            lhs.filterTags == rhs.filterTags &&
            lhs.interestTags == rhs.interestTags &&
            lhs.location == rhs.location &&
            lhs.text == rhs.text &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(custom)
        hasher.combine(expiresAt)
        hasher.combine(filterTags)
        hasher.combine(interestTags)
        hasher.combine(location)
        hasher.combine(text)
        hasher.combine(visibility)
    }
}
