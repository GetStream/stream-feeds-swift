//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RejectFollowRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var sourceFid: String
    public var targetFid: String

    public init(sourceFid: String, targetFid: String) {
        self.sourceFid = sourceFid
        self.targetFid = targetFid
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case sourceFid = "source_fid"
        case targetFid = "target_fid"
    }

    public static func == (lhs: RejectFollowRequest, rhs: RejectFollowRequest) -> Bool {
        lhs.sourceFid == rhs.sourceFid &&
            lhs.targetFid == rhs.targetFid
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(sourceFid)
        hasher.combine(targetFid)
    }
}
