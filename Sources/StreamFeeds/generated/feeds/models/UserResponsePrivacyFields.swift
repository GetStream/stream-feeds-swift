//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserResponsePrivacyFields: Sendable, Decodable {
    public let user: UserResponse
    public let invisible: Bool?
    /// The privacy settings of the user.
    public let privacySettings: PrivacySettingsResponse?

    public init(user: UserResponse, invisible: Bool? = nil, privacySettings: PrivacySettingsResponse? = nil) {
        self.user = user
        self.invisible = invisible
        self.privacySettings = privacySettings
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.user = try UserResponse(from: decoder)
        self.invisible = try container.decodeIfPresent(Bool.self, forKey: .invisible)
        self.privacySettings = try container.decodeIfPresent(PrivacySettingsResponse.self, forKey: .privacySettings)
    }
}

extension UserResponsePrivacyFields: Hashable {
    public static func == (lhs: UserResponsePrivacyFields, rhs: UserResponsePrivacyFields) -> Bool {
        lhs.user == rhs.user &&
            lhs.invisible == rhs.invisible &&
            lhs.privacySettings == rhs.privacySettings
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(user)
        hasher.combine(invisible)
        hasher.combine(privacySettings)
    }
}
