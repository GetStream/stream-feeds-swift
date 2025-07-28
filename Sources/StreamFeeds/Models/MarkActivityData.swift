//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct MarkActivityData: Equatable, Sendable {
    public let fid: String
    public let markAllRead: Bool?
    public let markAllSeen: Bool?
    public let markRead: [String]?
    public let markWatched: [String]?
}

extension ActivityMarkEvent {
    func toModel() -> MarkActivityData {
        .init(
            fid: fid,
            markAllRead: markAllRead,
            markAllSeen: markAllSeen,
            markRead: markRead,
            markWatched: markWatched
        )
    }
}
