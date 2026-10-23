//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedInputVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = FeedInputVisibility(rawValue: "private")
    public static let `public` = FeedInputVisibility(rawValue: "public")
    public static let followers = FeedInputVisibility(rawValue: "followers")
    public static let members = FeedInputVisibility(rawValue: "members")
    public static let visible = FeedInputVisibility(rawValue: "visible")
}

public final class FeedInput: Sendable, Codable, JSONEncodable {
    public let custom: [String: RawJSON]?
    public let description: String?
    public let filterTags: [String]?
    public let location: Location?
    public let members: [FeedMemberRequest]?
    public let name: String?
    public let visibility: FeedInputVisibility?

    public init(custom: [String: RawJSON]? = nil, description: String? = nil, filterTags: [String]? = nil, location: Location? = nil, members: [FeedMemberRequest]? = nil, name: String? = nil, visibility: FeedInputVisibility? = nil) {
        self.custom = custom
        self.description = description
        self.filterTags = filterTags
        self.location = location
        self.members = members
        self.name = name
        self.visibility = visibility
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.filterTags = try container.decodeIfPresent([String].self, forKey: .filterTags)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.members = try container.decodeIfPresent([FeedMemberRequest].self, forKey: .members)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.visibility = try container.decodeIfPresent(FeedInputVisibility.self, forKey: .visibility)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(filterTags, forKey: .filterTags)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(members, forKey: .members)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(visibility, forKey: .visibility)
    }
}

extension FeedInput: Hashable {
    public static func == (lhs: FeedInput, rhs: FeedInput) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.filterTags == rhs.filterTags &&
            lhs.location == rhs.location &&
            lhs.members == rhs.members &&
            lhs.name == rhs.name &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(filterTags)
        hasher.combine(location)
        hasher.combine(members)
        hasher.combine(name)
        hasher.combine(visibility)
    }
}
