//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedsEventPreferences: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comments: String?
    public var mentions: String?
    public var newFollowers: String?
    public var reactions: String?

    public init(comments: String? = nil, mentions: String? = nil, newFollowers: String? = nil, reactions: String? = nil) {
        self.comments = comments
        self.mentions = mentions
        self.newFollowers = newFollowers
        self.reactions = reactions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comments
        case mentions
        case newFollowers = "new_followers"
        case reactions
    }

    public static func == (lhs: FeedsEventPreferences, rhs: FeedsEventPreferences) -> Bool {
        lhs.comments == rhs.comments &&
            lhs.mentions == rhs.mentions &&
            lhs.newFollowers == rhs.newFollowers &&
            lhs.reactions == rhs.reactions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
        hasher.combine(mentions)
        hasher.combine(newFollowers)
        hasher.combine(reactions)
    }
}
