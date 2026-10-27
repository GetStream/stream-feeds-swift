//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedInput: @unchecked Sendable, Codable, JSONEncodable {
    public var custom: [String: RawJSON]?
    public var description: String?
    public var filterTags: [String]?
    public var members: [FeedMemberRequest]?
    public var name: String?
    /// Who can see and follow a feed.
    public var visibility: FeedVisibility?

    public init(custom: [String: RawJSON]? = nil, description: String? = nil, filterTags: [String]? = nil, members: [FeedMemberRequest]? = nil, name: String? = nil, visibility: FeedVisibility? = nil) {
        self.custom = custom
        self.description = description
        self.filterTags = filterTags
        self.members = members
        self.name = name
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case description
        case filterTags = "filter_tags"
        case members
        case name
        case visibility
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
