//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AcceptFollowRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Fully qualified ID of the source feed
    public var source: String
    /// Fully qualified ID of the target feed
    public var target: String

    public init(source: String, target: String) {
        self.source = source
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case source
        case target
    }
}

extension AcceptFollowRequest: Hashable {
    public static func == (lhs: AcceptFollowRequest, rhs: AcceptFollowRequest) -> Bool {
        lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(target)
    }
}
