//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddReactionRequest: Sendable, Codable, JSONEncodable {
    /// Whether to create a notification activity for this reaction
    public let createNotificationActivity: Bool?
    /// Custom data for the reaction
    public let custom: [String: RawJSON]?
    /// Whether to enforce unique reactions per user (remove other reaction types from the user when adding this one)
    public let enforceUnique: Bool?
    public let skipPush: Bool?
    /// Type of reaction
    public let type: String

    public init(createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, enforceUnique: Bool? = nil, skipPush: Bool? = nil, type: String) {
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.enforceUnique = enforceUnique
        self.skipPush = skipPush
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createNotificationActivity = try container.decodeIfPresent(Bool.self, forKey: .createNotificationActivity)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.enforceUnique = try container.decodeIfPresent(Bool.self, forKey: .enforceUnique)
        self.skipPush = try container.decodeIfPresent(Bool.self, forKey: .skipPush)
        self.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(createNotificationActivity, forKey: .createNotificationActivity)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(enforceUnique, forKey: .enforceUnique)
        try container.encodeIfPresent(skipPush, forKey: .skipPush)
        try container.encode(type, forKey: .type)
    }
}

extension AddReactionRequest: Hashable {
    public static func == (lhs: AddReactionRequest, rhs: AddReactionRequest) -> Bool {
        lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.enforceUnique == rhs.enforceUnique &&
            lhs.skipPush == rhs.skipPush &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(enforceUnique)
        hasher.combine(skipPush)
        hasher.combine(type)
    }
}
