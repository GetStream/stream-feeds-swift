//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Request to provide feedback on an activity
public final class ActivityFeedbackRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Whether to hide this activity
    public var hide: Bool?
    /// Whether to show less content like this
    public var showLess: Bool?
    /// Whether to show more content like this
    public var showMore: Bool?

    public init(hide: Bool? = nil, showLess: Bool? = nil, showMore: Bool? = nil) {
        self.hide = hide
        self.showLess = showLess
        self.showMore = showMore
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case hide
        case showLess = "show_less"
        case showMore = "show_more"
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
