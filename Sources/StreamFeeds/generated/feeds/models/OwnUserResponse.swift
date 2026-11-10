//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OwnUserResponse: Sendable, Decodable {
    public let user: UserResponse
    public let devices: [DeviceResponse]

    public init(user: UserResponse, devices: [DeviceResponse]) {
        self.user = user
        self.devices = devices
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.user = try UserResponse(from: decoder)
        self.devices = try container.decode([DeviceResponse].self, forKey: .devices)
    }
}

extension OwnUserResponse: Hashable {
    public static func == (lhs: OwnUserResponse, rhs: OwnUserResponse) -> Bool {
        lhs.user == rhs.user &&
            lhs.devices == rhs.devices
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(user)
        hasher.combine(devices)
    }
}
