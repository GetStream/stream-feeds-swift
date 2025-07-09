//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActionSequence: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var action: String
    public var blur: Bool
    public var cooldownPeriod: Int
    public var threshold: Int
    public var timeWindow: Int
    public var warning: Bool
    public var warningText: String

    public init(action: String, blur: Bool, cooldownPeriod: Int, threshold: Int, timeWindow: Int, warning: Bool, warningText: String) {
        self.action = action
        self.blur = blur
        self.cooldownPeriod = cooldownPeriod
        self.threshold = threshold
        self.timeWindow = timeWindow
        self.warning = warning
        self.warningText = warningText
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case blur
        case cooldownPeriod = "cooldown_period"
        case threshold
        case timeWindow = "time_window"
        case warning
        case warningText = "warning_text"
    }

    public static func == (lhs: ActionSequence, rhs: ActionSequence) -> Bool {
        lhs.action == rhs.action &&
            lhs.blur == rhs.blur &&
            lhs.cooldownPeriod == rhs.cooldownPeriod &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow &&
            lhs.warning == rhs.warning &&
            lhs.warningText == rhs.warningText
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(blur)
        hasher.combine(cooldownPeriod)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
        hasher.combine(warning)
        hasher.combine(warningText)
    }
}
