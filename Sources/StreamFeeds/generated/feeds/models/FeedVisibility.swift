//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Who can see and follow a feed.
public final class FeedVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = FeedVisibility(rawValue: "private")
    public static let `public` = FeedVisibility(rawValue: "public")
    public static let followers = FeedVisibility(rawValue: "followers")
    public static let members = FeedVisibility(rawValue: "members")
    public static let visible = FeedVisibility(rawValue: "visible")
}
