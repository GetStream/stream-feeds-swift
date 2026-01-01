//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RejectFollowRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var source: String
    public var target: String

    public init(source: String, target: String) {
        self.source = source
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case source
        case target
    }

    public static func == (lhs: RejectFollowRequest, rhs: RejectFollowRequest) -> Bool {
        lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(target)
    }
}
