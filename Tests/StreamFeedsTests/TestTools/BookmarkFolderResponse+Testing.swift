//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkFolderResponse {
    static func dummy(
        id: String = "folder-1",
        name: String = "Test Folder",
        createdAt: Date = .fixed(),
        updatedAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil
    ) -> BookmarkFolderResponse {
        BookmarkFolderResponse(
            createdAt: createdAt,
            custom: custom,
            id: id,
            name: name,
            updatedAt: updatedAt
        )
    }
}
