//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Ban information
public final class BanInfoResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// When the ban was created
    public var createdAt: Date
    /// User response object
    public var createdBy: UserResponse?
    /// When the ban expires
    public var expires: Date?
    /// Reason for the ban
    public var reason: String?
    /// Whether this is a shadow ban
    public var shadow: Bool?
    /// User response object
    public var user: UserResponse?

    public init(
        createdAt: Date,
        createdBy: UserResponse? = nil,
        expires: Date? = nil,
        reason: String? = nil,
        shadow: Bool? = nil,
        user: UserResponse? = nil
    ) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.expires = expires
        self.reason = reason
        self.shadow = shadow
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case createdBy = "created_by"
        case expires
        case reason
        case shadow
        case user
    }
}

extension BanInfoResponse: Hashable {
    public static func == (lhs: BanInfoResponse, rhs: BanInfoResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.expires == rhs.expires &&
            lhs.reason == rhs.reason &&
            lhs.shadow == rhs.shadow &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(expires)
        hasher.combine(reason)
        hasher.combine(shadow)
        hasher.combine(user)
    }
}
