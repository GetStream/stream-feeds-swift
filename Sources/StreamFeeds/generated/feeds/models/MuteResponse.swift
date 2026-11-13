//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MuteResponse: Sendable, Decodable {
    /// Object with mutes (if multiple users were muted)
    public let mutes: [UserMuteResponse]?
    /// A list of users that can't be found. Common cause for this is deleted users
    public let nonExistingUsers: [String]?
    public let ownUser: OwnUserResponse?

    public init(mutes: [UserMuteResponse]? = nil, nonExistingUsers: [String]? = nil, ownUser: OwnUserResponse? = nil) {
        self.mutes = mutes
        self.nonExistingUsers = nonExistingUsers
        self.ownUser = ownUser
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.mutes = try container.decodeIfPresent([UserMuteResponse].self, forKey: .mutes)
        self.nonExistingUsers = try container.decodeIfPresent([String].self, forKey: .nonExistingUsers)
        self.ownUser = try container.decodeIfPresent(OwnUserResponse.self, forKey: .ownUser)
    }
}

extension MuteResponse: Hashable {
    public static func == (lhs: MuteResponse, rhs: MuteResponse) -> Bool {
        lhs.mutes == rhs.mutes &&
            lhs.nonExistingUsers == rhs.nonExistingUsers &&
            lhs.ownUser == rhs.ownUser
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(mutes)
        hasher.combine(nonExistingUsers)
        hasher.combine(ownUser)
    }
}
