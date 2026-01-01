//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityFeedbackRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var hide: Bool?
    public var showLess: Bool?
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
