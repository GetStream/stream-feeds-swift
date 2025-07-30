//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderAction: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var banOptions: BanOptions?
    public var flagContentOptions: FlagContentOptions?
    public var flagUserOptions: FlagUserOptions?
    public var removeContentOptions: BlockContentOptions?
    public var type: String

    public init(banOptions: BanOptions? = nil, flagContentOptions: FlagContentOptions? = nil, flagUserOptions: FlagUserOptions? = nil, removeContentOptions: BlockContentOptions? = nil, type: String) {
        self.banOptions = banOptions
        self.flagContentOptions = flagContentOptions
        self.flagUserOptions = flagUserOptions
        self.removeContentOptions = removeContentOptions
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case banOptions = "ban_options"
        case flagContentOptions = "flag_content_options"
        case flagUserOptions = "flag_user_options"
        case removeContentOptions = "remove_content_options"
        case type
    }

    public static func == (lhs: RuleBuilderAction, rhs: RuleBuilderAction) -> Bool {
        lhs.banOptions == rhs.banOptions &&
            lhs.flagContentOptions == rhs.flagContentOptions &&
            lhs.flagUserOptions == rhs.flagUserOptions &&
            lhs.removeContentOptions == rhs.removeContentOptions &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(banOptions)
        hasher.combine(flagContentOptions)
        hasher.combine(flagUserOptions)
        hasher.combine(removeContentOptions)
        hasher.combine(type)
    }
}
