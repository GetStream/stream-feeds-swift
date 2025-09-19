//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkFolderResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil,
        id: String = "folder-1",
        name: String = "Test Folder",
        updatedAt: Date = .fixed()
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
