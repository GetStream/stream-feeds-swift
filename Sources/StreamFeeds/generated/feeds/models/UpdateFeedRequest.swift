//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFeedRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// If true, removes the geographic location from the feed
    public var clearLocation: Bool?
    /// Custom data for the feed
    public var custom: [String: RawJSON]?
    /// Description of the feed
    public var description: String?
    /// If true, enriches the feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public var enrichOwnFields: Bool?
    /// Tags used for filtering feeds
    public var filterTags: [String]?
    public var location: Location?
    /// Name of the feed
    public var name: String?

    public init(clearLocation: Bool? = nil, custom: [String: RawJSON]? = nil, description: String? = nil, enrichOwnFields: Bool? = nil, filterTags: [String]? = nil, location: Location? = nil, name: String? = nil) {
        self.clearLocation = clearLocation
        self.custom = custom
        self.description = description
        self.enrichOwnFields = enrichOwnFields
        self.filterTags = filterTags
        self.location = location
        self.name = name
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case clearLocation = "clear_location"
        case custom
        case description
        case enrichOwnFields = "enrich_own_fields"
        case filterTags = "filter_tags"
        case location
        case name
    }
}

extension UpdateFeedRequest: Hashable {
    public static func == (lhs: UpdateFeedRequest, rhs: UpdateFeedRequest) -> Bool {
        lhs.clearLocation == rhs.clearLocation &&
            lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.enrichOwnFields == rhs.enrichOwnFields &&
            lhs.filterTags == rhs.filterTags &&
            lhs.location == rhs.location &&
            lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(clearLocation)
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(enrichOwnFields)
        hasher.combine(filterTags)
        hasher.combine(location)
        hasher.combine(name)
    }
}
