//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityFeedbackRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var hide: Bool?
    public var muteUser: Bool?
    public var reason: String?
    public var report: Bool?
    public var showLess: Bool?

    public init(hide: Bool? = nil, muteUser: Bool? = nil, reason: String? = nil, report: Bool? = nil, showLess: Bool? = nil) {
        self.hide = hide
        self.muteUser = muteUser
        self.reason = reason
        self.report = report
        self.showLess = showLess
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case hide
        case muteUser = "mute_user"
        case reason
        case report
        case showLess = "show_less"
    }

    public static func == (lhs: ActivityFeedbackRequest, rhs: ActivityFeedbackRequest) -> Bool {
        lhs.hide == rhs.hide &&
            lhs.muteUser == rhs.muteUser &&
            lhs.reason == rhs.reason &&
            lhs.report == rhs.report &&
            lhs.showLess == rhs.showLess
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hide)
        hasher.combine(muteUser)
        hasher.combine(reason)
        hasher.combine(report)
        hasher.combine(showLess)
    }
}
