import Foundation
import StreamCore

public final class VelocityFilterConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var advancedFilters: Bool
    public var async: Bool?
    public var cascadingActions: Bool
    public var cidsPerUser: Int
    public var enabled: Bool
    public var firstMessageOnly: Bool
    public var rules: [VelocityFilterConfigRule]

    public init(advancedFilters: Bool, async: Bool? = nil, cascadingActions: Bool, cidsPerUser: Int, enabled: Bool, firstMessageOnly: Bool, rules: [VelocityFilterConfigRule]) {
        self.advancedFilters = advancedFilters
        self.async = async
        self.cascadingActions = cascadingActions
        self.cidsPerUser = cidsPerUser
        self.enabled = enabled
        self.firstMessageOnly = firstMessageOnly
        self.rules = rules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case advancedFilters = "advanced_filters"
        case async
        case cascadingActions = "cascading_actions"
        case cidsPerUser = "cids_per_user"
        case enabled
        case firstMessageOnly = "first_message_only"
        case rules
    }

    public static func == (lhs: VelocityFilterConfig, rhs: VelocityFilterConfig) -> Bool {
        lhs.advancedFilters == rhs.advancedFilters &&
            lhs.async == rhs.async &&
            lhs.cascadingActions == rhs.cascadingActions &&
            lhs.cidsPerUser == rhs.cidsPerUser &&
            lhs.enabled == rhs.enabled &&
            lhs.firstMessageOnly == rhs.firstMessageOnly &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(advancedFilters)
        hasher.combine(async)
        hasher.combine(cascadingActions)
        hasher.combine(cidsPerUser)
        hasher.combine(enabled)
        hasher.combine(firstMessageOnly)
        hasher.combine(rules)
    }
}
