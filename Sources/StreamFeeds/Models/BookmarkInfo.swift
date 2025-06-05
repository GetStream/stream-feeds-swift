//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct BookmarkInfo: Sendable {
    public let activityId: String
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let folder: BookmarkFolderResponse
    public let updatedAt: Date
    public let user: UserResponse
    
    init(from response: BookmarkResponse) {
        self.activityId = response.activityId
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.folder = response.folder
        self.updatedAt = response.updatedAt
        self.user = response.user
    }
}

extension BookmarkInfo: Identifiable {
    public var id: String {
        activityId + user.id
    }
}

// TODO: Event is missing the response

extension BookmarkAddedEvent {
    var bookmark: BookmarkResponse? {
        guard let user = user?.toUserResponse() else { return nil }
        return BookmarkResponse(
            activityId: activityId,
            createdAt: createdAt,
            custom: custom,
            folder: BookmarkFolderResponse(
                createdAt: Date(),
                id: "bookmarks",
                name: "Bookmarks",
                updatedAt: Date()
            ),
            updatedAt: createdAt,
            user: user
        )
    }
}
