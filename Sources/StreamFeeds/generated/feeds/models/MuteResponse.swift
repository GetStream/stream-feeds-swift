//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MuteResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String
    /// Object with mutes (if multiple users were muted)
    public var mutes: [UserMuteResponse]?
    /// A list of users that can't be found. Common cause for this is deleted users
    public var nonExistingUsers: [String]?
    public var ownUser: OwnUserResponse?

    public init(duration: String, mutes: [UserMuteResponse]? = nil, nonExistingUsers: [String]? = nil, ownUser: OwnUserResponse? = nil) {
        self.duration = duration
        self.mutes = mutes
        self.nonExistingUsers = nonExistingUsers
        self.ownUser = ownUser
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case mutes
        case nonExistingUsers = "non_existing_users"
        case ownUser = "own_user"
    }
}

extension MuteResponse: Hashable {
    public static func == (lhs: MuteResponse, rhs: MuteResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.mutes == rhs.mutes &&
            lhs.nonExistingUsers == rhs.nonExistingUsers &&
            lhs.ownUser == rhs.ownUser
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(mutes)
        hasher.combine(nonExistingUsers)
        hasher.combine(ownUser)
    }
}
