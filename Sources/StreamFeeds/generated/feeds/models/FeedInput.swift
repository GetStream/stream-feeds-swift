import Foundation
import StreamCore

public final class FeedInput: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum FeedInputVisibility: String, Sendable, Codable, CaseIterable {
        case `private`
        case `public`
        case followers
        case members
        case visible
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var custom: [String: RawJSON]?
    public var description: String?
    public var members: [FeedMemberRequest]?
    public var name: String?
    public var visibility: FeedInputVisibility?

    public init(custom: [String: RawJSON]? = nil, description: String? = nil, members: [FeedMemberRequest]? = nil, name: String? = nil, visibility: FeedInputVisibility? = nil) {
        self.custom = custom
        self.description = description
        self.members = members
        self.name = name
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case description
        case members
        case name
        case visibility
    }

    public static func == (lhs: FeedInput, rhs: FeedInput) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.members == rhs.members &&
            lhs.name == rhs.name &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(members)
        hasher.combine(name)
        hasher.combine(visibility)
    }
}
