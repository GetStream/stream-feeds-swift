//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderAction: @unchecked Sendable, Codable, JSONEncodable {
    public enum RuleBuilderActionType: String, Sendable, Codable, CaseIterable {
        case banUser = "ban_user"
        case blockContent = "block_content"
        case blur
        case bounceContent = "bounce_content"
        case bounceFlagContent = "bounce_flag_content"
        case bounceRemoveContent = "bounce_remove_content"
        case callBlur = "call_blur"
        case callWarning = "call_warning"
        case endCall = "end_call"
        case flagContent = "flag_content"
        case flagUser = "flag_user"
        case kickUser = "kick_user"
        case muteAudio = "mute_audio"
        case muteVideo = "mute_video"
        case shadowContent = "shadow_content"
        case warning
        case webhookOnly = "webhook_only"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var banOptions: BanOptions?
    public var flagUserOptions: FlagUserOptions?
    public var reason: String?
    public var skipInbox: Bool?
    public var type: RuleBuilderActionType?

    public init(
        banOptions: BanOptions? = nil,
        flagUserOptions: FlagUserOptions? = nil,
        reason: String? = nil,
        skipInbox: Bool? = nil
    ) {
        self.banOptions = banOptions
        self.flagUserOptions = flagUserOptions
        self.reason = reason
        self.skipInbox = skipInbox
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case banOptions = "ban_options"
        case flagUserOptions = "flag_user_options"
        case reason
        case skipInbox = "skip_inbox"
        case type
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
