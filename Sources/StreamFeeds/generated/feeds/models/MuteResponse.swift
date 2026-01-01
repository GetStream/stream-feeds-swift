//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MuteResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var mutes: [UserMute]?
    public var nonExistingUsers: [String]?
    public var ownUser: OwnUser?

    public init(duration: String, mutes: [UserMute]? = nil, nonExistingUsers: [String]? = nil, ownUser: OwnUser? = nil) {
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
