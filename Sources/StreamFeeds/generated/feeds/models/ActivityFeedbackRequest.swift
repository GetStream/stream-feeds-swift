//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Request to provide feedback on an activity
public final class ActivityFeedbackRequest: Sendable, Encodable, JSONEncodable {
    /// Whether to hide this activity
    public let hide: Bool?
    /// Whether to show less content like this
    public let showLess: Bool?
    /// Whether to show more content like this
    public let showMore: Bool?

    public init(hide: Bool? = nil, showLess: Bool? = nil, showMore: Bool? = nil) {
        self.hide = hide
        self.showLess = showLess
        self.showMore = showMore
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(hide, forKey: .hide)
        try container.encodeIfPresent(showLess, forKey: .showLess)
        try container.encodeIfPresent(showMore, forKey: .showMore)
    }
}

extension ActivityFeedbackRequest: Hashable {
    public static func == (lhs: ActivityFeedbackRequest, rhs: ActivityFeedbackRequest) -> Bool {
        lhs.hide == rhs.hide &&
            lhs.showLess == rhs.showLess &&
            lhs.showMore == rhs.showMore
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hide)
        hasher.combine(showLess)
        hasher.combine(showMore)
    }
}
