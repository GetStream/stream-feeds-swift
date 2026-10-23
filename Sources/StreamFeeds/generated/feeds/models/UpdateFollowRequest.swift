//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFollowRequestPushPreference: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let all = UpdateFollowRequestPushPreference(rawValue: "all")
    public static let none = UpdateFollowRequestPushPreference(rawValue: "none")
}

public final class UpdateFollowRequest: Sendable, Codable, JSONEncodable {
    /// Custom data for the follow relationship
    public let custom: [String: RawJSON]?
    /// Push preference for the follow relationship
    public let pushPreference: UpdateFollowRequestPushPreference?
    /// Fully qualified ID of the source feed
    public let source: String
    /// Fully qualified ID of the target feed
    public let target: String

    public init(custom: [String: RawJSON]? = nil, pushPreference: UpdateFollowRequestPushPreference? = nil, source: String, target: String) {
        self.custom = custom
        self.pushPreference = pushPreference
        self.source = source
        self.target = target
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.pushPreference = try container.decodeIfPresent(UpdateFollowRequestPushPreference.self, forKey: .pushPreference)
        self.source = try container.decode(String.self, forKey: .source)
        self.target = try container.decode(String.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(pushPreference, forKey: .pushPreference)
        try container.encode(source, forKey: .source)
        try container.encode(target, forKey: .target)
    }
}

extension UpdateFollowRequest: Hashable {
    public static func == (lhs: UpdateFollowRequest, rhs: UpdateFollowRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.pushPreference == rhs.pushPreference &&
            lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(pushPreference)
        hasher.combine(source)
        hasher.combine(target)
    }
}
