//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct BookmarkFolderData: Identifiable, Equatable, Sendable {
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let id: String
    public let name: String
    public let updatedAt: Date
    
    var localFilterData: LocalFilterData?
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

// MARK: - Local Filter Matching

extension BookmarkFolderData {
    struct LocalFilterData: Equatable, Sendable {
        var userId: String = ""
    }

    func toLocalFilterModel(userId: String) -> Self {
        var data = self
        data.localFilterData = LocalFilterData(userId: userId)
        return data
    }
}
