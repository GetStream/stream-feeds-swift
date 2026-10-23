//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VelocityFilterConfigRuleAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let ban = VelocityFilterConfigRuleAction(rawValue: "ban")
    public static let flag = VelocityFilterConfigRuleAction(rawValue: "flag")
    public static let remove = VelocityFilterConfigRuleAction(rawValue: "remove")
    public static let shadow = VelocityFilterConfigRuleAction(rawValue: "shadow")
}

public final class VelocityFilterConfigRuleCascadingAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let ban = VelocityFilterConfigRuleCascadingAction(rawValue: "ban")
    public static let flag = VelocityFilterConfigRuleCascadingAction(rawValue: "flag")
    public static let remove = VelocityFilterConfigRuleCascadingAction(rawValue: "remove")
    public static let shadow = VelocityFilterConfigRuleCascadingAction(rawValue: "shadow")
}

public final class VelocityFilterConfigRule: Sendable, Codable, JSONEncodable {
    public let action: VelocityFilterConfigRuleAction
    public let banDuration: Int
    public let cascadingAction: VelocityFilterConfigRuleCascadingAction
    public let cascadingThreshold: Int
    public let checkMessageContext: Bool
    public let fastSpamThreshold: Int
    public let fastSpamTtl: Int
    public let ipBan: Bool
    public let probationPeriod: Int
    public let shadowBan: Bool
    public let slowSpamBanDuration: Int?
    public let slowSpamThreshold: Int
    public let slowSpamTtl: Int
    public let urlOnly: Bool

    public init(action: VelocityFilterConfigRuleAction, banDuration: Int, cascadingAction: VelocityFilterConfigRuleCascadingAction, cascadingThreshold: Int, checkMessageContext: Bool, fastSpamThreshold: Int, fastSpamTtl: Int, ipBan: Bool, probationPeriod: Int, shadowBan: Bool, slowSpamBanDuration: Int? = nil, slowSpamThreshold: Int, slowSpamTtl: Int, urlOnly: Bool) {
        self.action = action
        self.banDuration = banDuration
        self.cascadingAction = cascadingAction
        self.cascadingThreshold = cascadingThreshold
        self.checkMessageContext = checkMessageContext
        self.fastSpamThreshold = fastSpamThreshold
        self.fastSpamTtl = fastSpamTtl
        self.ipBan = ipBan
        self.probationPeriod = probationPeriod
        self.shadowBan = shadowBan
        self.slowSpamBanDuration = slowSpamBanDuration
        self.slowSpamThreshold = slowSpamThreshold
        self.slowSpamTtl = slowSpamTtl
        self.urlOnly = urlOnly
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(VelocityFilterConfigRuleAction.self, forKey: .action)
        self.banDuration = try container.decode(Int.self, forKey: .banDuration)
        self.cascadingAction = try container.decode(VelocityFilterConfigRuleCascadingAction.self, forKey: .cascadingAction)
        self.cascadingThreshold = try container.decode(Int.self, forKey: .cascadingThreshold)
        self.checkMessageContext = try container.decode(Bool.self, forKey: .checkMessageContext)
        self.fastSpamThreshold = try container.decode(Int.self, forKey: .fastSpamThreshold)
        self.fastSpamTtl = try container.decode(Int.self, forKey: .fastSpamTtl)
        self.ipBan = try container.decode(Bool.self, forKey: .ipBan)
        self.probationPeriod = try container.decode(Int.self, forKey: .probationPeriod)
        self.shadowBan = try container.decode(Bool.self, forKey: .shadowBan)
        self.slowSpamBanDuration = try container.decodeIfPresent(Int.self, forKey: .slowSpamBanDuration)
        self.slowSpamThreshold = try container.decode(Int.self, forKey: .slowSpamThreshold)
        self.slowSpamTtl = try container.decode(Int.self, forKey: .slowSpamTtl)
        self.urlOnly = try container.decode(Bool.self, forKey: .urlOnly)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(banDuration, forKey: .banDuration)
        try container.encode(cascadingAction, forKey: .cascadingAction)
        try container.encode(cascadingThreshold, forKey: .cascadingThreshold)
        try container.encode(checkMessageContext, forKey: .checkMessageContext)
        try container.encode(fastSpamThreshold, forKey: .fastSpamThreshold)
        try container.encode(fastSpamTtl, forKey: .fastSpamTtl)
        try container.encode(ipBan, forKey: .ipBan)
        try container.encode(probationPeriod, forKey: .probationPeriod)
        try container.encode(shadowBan, forKey: .shadowBan)
        try container.encodeIfPresent(slowSpamBanDuration, forKey: .slowSpamBanDuration)
        try container.encode(slowSpamThreshold, forKey: .slowSpamThreshold)
        try container.encode(slowSpamTtl, forKey: .slowSpamTtl)
        try container.encode(urlOnly, forKey: .urlOnly)
    }
}

extension VelocityFilterConfigRule: Hashable {
    public static func == (lhs: VelocityFilterConfigRule, rhs: VelocityFilterConfigRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.banDuration == rhs.banDuration &&
            lhs.cascadingAction == rhs.cascadingAction &&
            lhs.cascadingThreshold == rhs.cascadingThreshold &&
            lhs.checkMessageContext == rhs.checkMessageContext &&
            lhs.fastSpamThreshold == rhs.fastSpamThreshold &&
            lhs.fastSpamTtl == rhs.fastSpamTtl &&
            lhs.ipBan == rhs.ipBan &&
            lhs.probationPeriod == rhs.probationPeriod &&
            lhs.shadowBan == rhs.shadowBan &&
            lhs.slowSpamBanDuration == rhs.slowSpamBanDuration &&
            lhs.slowSpamThreshold == rhs.slowSpamThreshold &&
            lhs.slowSpamTtl == rhs.slowSpamTtl &&
            lhs.urlOnly == rhs.urlOnly
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(banDuration)
        hasher.combine(cascadingAction)
        hasher.combine(cascadingThreshold)
        hasher.combine(checkMessageContext)
        hasher.combine(fastSpamThreshold)
        hasher.combine(fastSpamTtl)
        hasher.combine(ipBan)
        hasher.combine(probationPeriod)
        hasher.combine(shadowBan)
        hasher.combine(slowSpamBanDuration)
        hasher.combine(slowSpamThreshold)
        hasher.combine(slowSpamTtl)
        hasher.combine(urlOnly)
    }
}
