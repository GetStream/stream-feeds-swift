//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFollowRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum UpdateFollowRequestPushPreference: String, Sendable, Codable, CaseIterable {
        case all
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var createNotificationActivity: Bool?
    public var custom: [String: RawJSON]?
    public var followerRole: String?
    public var pushPreference: UpdateFollowRequestPushPreference?
    public var sourceFid: String
    public var targetFid: String

    public init(createNotificationActivity: Bool? = nil, custom: [String: RawJSON]? = nil, followerRole: String? = nil, pushPreference: UpdateFollowRequestPushPreference? = nil, sourceFid: String, targetFid: String) {
        self.createNotificationActivity = createNotificationActivity
        self.custom = custom
        self.followerRole = followerRole
        self.pushPreference = pushPreference
        self.sourceFid = sourceFid
        self.targetFid = targetFid
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createNotificationActivity = "create_notification_activity"
        case custom
        case followerRole = "follower_role"
        case pushPreference = "push_preference"
        case sourceFid = "source_fid"
        case targetFid = "target_fid"
    }

    public static func == (lhs: UpdateFollowRequest, rhs: UpdateFollowRequest) -> Bool {
        lhs.createNotificationActivity == rhs.createNotificationActivity &&
            lhs.custom == rhs.custom &&
            lhs.followerRole == rhs.followerRole &&
            lhs.pushPreference == rhs.pushPreference &&
            lhs.sourceFid == rhs.sourceFid &&
            lhs.targetFid == rhs.targetFid
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createNotificationActivity)
        hasher.combine(custom)
        hasher.combine(followerRole)
        hasher.combine(pushPreference)
        hasher.combine(sourceFid)
        hasher.combine(targetFid)
    }
}
