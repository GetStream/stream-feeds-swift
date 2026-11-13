//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OwnUserResponse: Sendable, Decodable {
    public let user: UserResponse
    public let devices: [DeviceResponse]
    public let mutes: [UserMuteResponse]
    /// The push preference details.
    public let pushPreferences: PushPreferencesResponse?

    public init(user: UserResponse, devices: [DeviceResponse], mutes: [UserMuteResponse], pushPreferences: PushPreferencesResponse? = nil) {
        self.user = user
        self.devices = devices
        self.mutes = mutes
        self.pushPreferences = pushPreferences
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.user = try UserResponse(from: decoder)
        self.devices = try container.decode([DeviceResponse].self, forKey: .devices)
        self.mutes = try container.decode([UserMuteResponse].self, forKey: .mutes)
        self.pushPreferences = try container.decodeIfPresent(PushPreferencesResponse.self, forKey: .pushPreferences)
    }
}

extension OwnUserResponse: Hashable {
    public static func == (lhs: OwnUserResponse, rhs: OwnUserResponse) -> Bool {
        lhs.user == rhs.user &&
            lhs.devices == rhs.devices &&
            lhs.mutes == rhs.mutes &&
            lhs.pushPreferences == rhs.pushPreferences
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(user)
        hasher.combine(devices)
        hasher.combine(mutes)
        hasher.combine(pushPreferences)
    }
}
