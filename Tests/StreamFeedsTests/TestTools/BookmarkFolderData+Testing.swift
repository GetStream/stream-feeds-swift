//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension BookmarkFolderData {
    static func dummy(
        id: String = "folder-1",
        name: String = "Test Folder",
        createdAt: Date = .fixed(),
        updatedAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil
    ) -> BookmarkFolderData {
        BookmarkFolderData(
            createdAt: createdAt,
            custom: custom,
            id: id,
            name: name,
            updatedAt: updatedAt
        )
    }
}
