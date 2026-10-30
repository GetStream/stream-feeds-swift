//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Who can see and follow a feed.
public enum FeedVisibility: String, Sendable, Codable, CaseIterable {
    case `private`
    case `public`
    case followers
    case members
    case visible
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = FeedVisibility(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
