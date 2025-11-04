//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class StoriesConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var skipWatched: Bool?
    public var trackWatched: Bool?

    public init(skipWatched: Bool? = nil, trackWatched: Bool? = nil) {
        self.skipWatched = skipWatched
        self.trackWatched = trackWatched
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case skipWatched = "skip_watched"
        case trackWatched = "track_watched"
    }

    public static func == (lhs: StoriesConfig, rhs: StoriesConfig) -> Bool {
        lhs.skipWatched == rhs.skipWatched &&
        lhs.trackWatched == rhs.trackWatched
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(skipWatched)
        hasher.combine(trackWatched)
    }
}
