//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct BookmarkData: Equatable, Sendable {
    public private(set) var activity: ActivityData
    /// The bookmarked comment when `objectType` is `comment`.
    public let comment: CommentData?
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public internal(set) var folder: BookmarkFolderData?
    /// The identifier of the bookmarked activity or comment.
    public let objectId: String
    /// The type of the bookmarked object, `activity` or `comment`.
    public let objectType: String
    public let updatedAt: Date
    public let user: UserData
}

extension BookmarkData: Identifiable {
    public var id: String {
        "\(user.id)-\(objectId)"
    }
}

// MARK: - Mutating the Data

extension BookmarkData {
    mutating func merge(with incomingData: ActivityData) {
        activity.merge(with: incomingData)
    }

    mutating func merge(with incomingData: BookmarkData) {
        let activity = activity
        self = incomingData
        self.activity = activity
        self.activity.merge(with: incomingData.activity)
    }
    
    // MARK: - Current Feed Capabilities
    
    mutating func mergeFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) {
        activity.mergeFeedOwnCapabilities(from: capabilitiesMap)
    }
    
    func withFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) -> BookmarkData {
        var updated = self
        updated.mergeFeedOwnCapabilities(from: capabilitiesMap)
        return updated
    }
}

// MARK: - Model Conversions

extension BookmarkResponse {
    func toModel() -> BookmarkData {
        BookmarkData(
            activity: activity.toModel(),
            comment: comment?.toModel(),
            createdAt: createdAt,
            custom: custom,
            folder: folder?.toModel(),
            objectId: objectId,
            objectType: objectType,
            updatedAt: updatedAt,
            user: user.toModel()
        )
    }
}
