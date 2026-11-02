//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedInput: Sendable, Encodable, JSONEncodable {
    public let custom: [String: RawJSON]?
    public let description: String?
    public let filterTags: [String]?
    public let members: [FeedMemberRequest]?
    public let name: String?
    /// Who can see and follow a feed.
    public let visibility: FeedVisibility?

    public init(custom: [String: RawJSON]? = nil, description: String? = nil, filterTags: [String]? = nil, members: [FeedMemberRequest]? = nil, name: String? = nil, visibility: FeedVisibility? = nil) {
        self.custom = custom
        self.description = description
        self.filterTags = filterTags
        self.members = members
        self.name = name
        self.visibility = visibility
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(filterTags, forKey: .filterTags)
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
            lhs.members == rhs.members &&
            lhs.name == rhs.name &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(filterTags)
        hasher.combine(members)
        hasher.combine(name)
        hasher.combine(visibility)
    }
}
