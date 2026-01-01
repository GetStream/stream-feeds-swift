//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ActivityMarkData: Equatable, Sendable {
    public let feed: FeedId
    public let markAllRead: Bool
    public let markAllSeen: Bool
    public let markRead: Set<String>
    public let markWatched: Set<String>
}

extension ActivityMarkEvent {
    func toModel() -> ActivityMarkData {
        .init(
            feed: FeedId(rawValue: fid),
            markAllRead: markAllRead ?? false,
            markAllSeen: markAllSeen ?? false,
            markRead: Set(markRead ?? []),
            markWatched: Set(markWatched ?? [])
        )
    }
}

extension MarkActivityRequest {
    func toModel(feed: FeedId) -> ActivityMarkData {
        .init(
            feed: feed,
            markAllRead: markAllRead ?? false,
            markAllSeen: markAllSeen ?? false,
            markRead: Set(markRead ?? []),
            markWatched: Set(markWatched ?? [])
        )
    }
}
