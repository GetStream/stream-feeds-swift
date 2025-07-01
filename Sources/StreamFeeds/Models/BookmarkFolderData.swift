//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct BookmarkFolderData: Identifiable, Sendable {
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let id: String
    public let name: String
    public let updatedAt: Date
}

// MARK: - Model Conversions

extension BookmarkFolderResponse {
    func toModel() -> BookmarkFolderData {
        BookmarkFolderData(
            createdAt: createdAt,
            custom: custom,
            id: id,
            name: name,
            updatedAt: updatedAt
        )
    }
}
