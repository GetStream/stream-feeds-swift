//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFollowRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Custom data for the follow relationship
    public var custom: [String: RawJSON]?
    /// Push preference for the follow relationship
    public var pushPreference: FollowPushPreference?
    /// Fully qualified ID of the source feed
    public var source: String
    /// Fully qualified ID of the target feed
    public var target: String

    public init(custom: [String: RawJSON]? = nil, pushPreference: FollowPushPreference? = nil, source: String, target: String) {
        self.custom = custom
        self.pushPreference = pushPreference
        self.source = source
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case pushPreference = "push_preference"
        case source
        case target
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.pushPreference = try container.decodeIfPresent(FollowPushPreference.self, forKey: .pushPreference)
        self.source = try container.decode(String.self, forKey: .source)
        self.target = try container.decode(String.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
