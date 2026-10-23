//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFeedRequest: Sendable, Codable, JSONEncodable {
    /// If true, removes the geographic location from the feed
    public let clearLocation: Bool?
    /// Custom data for the feed
    public let custom: [String: RawJSON]?
    /// Description of the feed
    public let description: String?
    /// If true, enriches the feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public let enrichOwnFields: Bool?
    /// Tags used for filtering feeds
    public let filterTags: [String]?
    public let location: Location?
    /// Name of the feed
    public let name: String?

    public init(clearLocation: Bool? = nil, custom: [String: RawJSON]? = nil, description: String? = nil, enrichOwnFields: Bool? = nil, filterTags: [String]? = nil, location: Location? = nil, name: String? = nil) {
        self.clearLocation = clearLocation
        self.custom = custom
        self.description = description
        self.enrichOwnFields = enrichOwnFields
        self.filterTags = filterTags
        self.location = location
        self.name = name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.clearLocation = try container.decodeIfPresent(Bool.self, forKey: .clearLocation)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
        self.filterTags = try container.decodeIfPresent([String].self, forKey: .filterTags)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(clearLocation, forKey: .clearLocation)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
        try container.encodeIfPresent(filterTags, forKey: .filterTags)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(name, forKey: .name)
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
