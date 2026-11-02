//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Ban information
public final class BanInfoResponse: Sendable, Decodable {
    /// When the ban was created
    public let createdAt: Date
    /// User response object
    public let createdBy: UserResponse?
    /// When the ban expires
    public let expires: Date?
    /// Reason for the ban
    public let reason: String?
    /// Whether this is a shadow ban
    public let shadow: Bool?

    public init(createdAt: Date, createdBy: UserResponse? = nil, expires: Date? = nil, reason: String? = nil, shadow: Bool? = nil) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.expires = expires
        self.reason = reason
        self.shadow = shadow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.createdBy = try container.decodeIfPresent(UserResponse.self, forKey: .createdBy)
        self.expires = try container.decodeIfPresent(Date.self, forKey: .expires)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.shadow = try container.decodeIfPresent(Bool.self, forKey: .shadow)
    }
}

extension BanInfoResponse: Hashable {
    public static func == (lhs: BanInfoResponse, rhs: BanInfoResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.expires == rhs.expires &&
            lhs.reason == rhs.reason &&
            lhs.shadow == rhs.shadow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(expires)
        hasher.combine(reason)
        hasher.combine(shadow)
    }
}
