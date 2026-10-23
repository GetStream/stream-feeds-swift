//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RejectFollowRequest: Sendable, Codable, JSONEncodable {
    /// Fully qualified ID of the source feed
    public let source: String
    /// Fully qualified ID of the target feed
    public let target: String

    public init(source: String, target: String) {
        self.source = source
        self.target = target
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.source = try container.decode(String.self, forKey: .source)
        self.target = try container.decode(String.self, forKey: .target)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(source, forKey: .source)
        try container.encode(target, forKey: .target)
    }
}

extension RejectFollowRequest: Hashable {
    public static func == (lhs: RejectFollowRequest, rhs: RejectFollowRequest) -> Bool {
        lhs.source == rhs.source &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(target)
    }
}
