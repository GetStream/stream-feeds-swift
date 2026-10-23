//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderActionType: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let banUser = RuleBuilderActionType(rawValue: "ban_user")
    public static let blockContent = RuleBuilderActionType(rawValue: "block_content")
    public static let blur = RuleBuilderActionType(rawValue: "blur")
    public static let bounceContent = RuleBuilderActionType(rawValue: "bounce_content")
    public static let bounceFlagContent = RuleBuilderActionType(rawValue: "bounce_flag_content")
    public static let bounceRemoveContent = RuleBuilderActionType(rawValue: "bounce_remove_content")
    public static let callBlur = RuleBuilderActionType(rawValue: "call_blur")
    public static let callWarning = RuleBuilderActionType(rawValue: "call_warning")
    public static let endCall = RuleBuilderActionType(rawValue: "end_call")
    public static let flagContent = RuleBuilderActionType(rawValue: "flag_content")
    public static let flagUser = RuleBuilderActionType(rawValue: "flag_user")
    public static let kickUser = RuleBuilderActionType(rawValue: "kick_user")
    public static let muteAudio = RuleBuilderActionType(rawValue: "mute_audio")
    public static let muteVideo = RuleBuilderActionType(rawValue: "mute_video")
    public static let shadowContent = RuleBuilderActionType(rawValue: "shadow_content")
    public static let warning = RuleBuilderActionType(rawValue: "warning")
    public static let webhookOnly = RuleBuilderActionType(rawValue: "webhook_only")
}

public final class RuleBuilderAction: Sendable, Codable, JSONEncodable {
    public let banOptions: BanOptions?
    public let flagUserOptions: FlagUserOptions?
    public let reason: String?
    public let skipInbox: Bool?
    public let type: RuleBuilderActionType?

    public init(banOptions: BanOptions? = nil, flagUserOptions: FlagUserOptions? = nil, reason: String? = nil, skipInbox: Bool? = nil, type: RuleBuilderActionType? = nil) {
        self.banOptions = banOptions
        self.flagUserOptions = flagUserOptions
        self.reason = reason
        self.skipInbox = skipInbox
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.banOptions = try container.decodeIfPresent(BanOptions.self, forKey: .banOptions)
        self.flagUserOptions = try container.decodeIfPresent(FlagUserOptions.self, forKey: .flagUserOptions)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.skipInbox = try container.decodeIfPresent(Bool.self, forKey: .skipInbox)
        self.type = try container.decodeIfPresent(RuleBuilderActionType.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(banOptions, forKey: .banOptions)
        try container.encodeIfPresent(flagUserOptions, forKey: .flagUserOptions)
        try container.encodeIfPresent(reason, forKey: .reason)
        try container.encodeIfPresent(skipInbox, forKey: .skipInbox)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

extension RuleBuilderAction: Hashable {
    public static func == (lhs: RuleBuilderAction, rhs: RuleBuilderAction) -> Bool {
        lhs.banOptions == rhs.banOptions &&
            lhs.flagUserOptions == rhs.flagUserOptions &&
            lhs.reason == rhs.reason &&
            lhs.skipInbox == rhs.skipInbox &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(banOptions)
        hasher.combine(flagUserOptions)
        hasher.combine(reason)
        hasher.combine(skipInbox)
        hasher.combine(type)
    }
}
