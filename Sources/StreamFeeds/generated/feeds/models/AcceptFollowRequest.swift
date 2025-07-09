//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AcceptFollowRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var followerRole: String?
    public var sourceFid: String
    public var targetFid: String

    public init(followerRole: String? = nil, sourceFid: String, targetFid: String) {
        self.followerRole = followerRole
        self.sourceFid = sourceFid
        self.targetFid = targetFid
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case followerRole = "follower_role"
        case sourceFid = "source_fid"
        case targetFid = "target_fid"
    }

    public static func == (lhs: AcceptFollowRequest, rhs: AcceptFollowRequest) -> Bool {
        lhs.followerRole == rhs.followerRole &&
            lhs.sourceFid == rhs.sourceFid &&
            lhs.targetFid == rhs.targetFid
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(followerRole)
        hasher.combine(sourceFid)
        hasher.combine(targetFid)
    }
}
