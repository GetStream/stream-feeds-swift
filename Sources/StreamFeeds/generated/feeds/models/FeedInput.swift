import Foundation
import StreamCore

public final class FeedInput: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum FeedVisibility: String, Sendable, Codable, CaseIterable {
        case followers
        case `private` = "private"
        case `public` = "public"
        case restricted = "restricted"
        case visible = "visible"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue)
            {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var custom: [String: RawJSON]?
    public var members: [FeedMemberPayload]?
    public var visibility: String?

    public init(custom: [String: RawJSON]? = nil, members: [FeedMemberPayload]? = nil, visibility: String? = nil) {
        self.custom = custom
        self.members = members
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case members
        case visibility
    }

    public static func == (lhs: FeedInput, rhs: FeedInput) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.members == rhs.members &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(members)
        hasher.combine(visibility)
    }
}
