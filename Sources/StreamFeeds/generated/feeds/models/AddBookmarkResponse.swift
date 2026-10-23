//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddBookmarkResponse: Sendable, Codable, JSONEncodable {
    public let bookmark: BookmarkResponse
    public let duration: String

    public init(bookmark: BookmarkResponse, duration: String) {
        self.bookmark = bookmark
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmark = try container.decode(BookmarkResponse.self, forKey: .bookmark)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(bookmark, forKey: .bookmark)
        try container.encode(duration, forKey: .duration)
    }
}

extension AddBookmarkResponse: Hashable {
    public static func == (lhs: AddBookmarkResponse, rhs: AddBookmarkResponse) -> Bool {
        lhs.bookmark == rhs.bookmark &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmark)
        hasher.combine(duration)
    }
}
