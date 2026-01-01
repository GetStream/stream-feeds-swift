//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderAction: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var banOptions: BanOptions?
    public var flagUserOptions: FlagUserOptions?
    public var type: String?

    public init(banOptions: BanOptions? = nil, flagUserOptions: FlagUserOptions? = nil) {
        self.banOptions = banOptions
        self.flagUserOptions = flagUserOptions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case banOptions = "ban_options"
        case flagUserOptions = "flag_user_options"
        case type
    }

    public static func == (lhs: RuleBuilderAction, rhs: RuleBuilderAction) -> Bool {
        lhs.banOptions == rhs.banOptions &&
            lhs.flagUserOptions == rhs.flagUserOptions &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(banOptions)
        hasher.combine(flagUserOptions)
        hasher.combine(type)
    }
}
