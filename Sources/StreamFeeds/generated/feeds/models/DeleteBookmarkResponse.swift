//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteBookmarkResponse: Sendable, Decodable {
    public let bookmark: BookmarkResponse

    public init(bookmark: BookmarkResponse) {
        self.bookmark = bookmark
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmark = try container.decode(BookmarkResponse.self, forKey: .bookmark)
    }
}

extension DeleteBookmarkResponse: Hashable {
    public static func == (lhs: DeleteBookmarkResponse, rhs: DeleteBookmarkResponse) -> Bool {
        lhs.bookmark == rhs.bookmark
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmark)
    }
}
