//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagUserOptions: @unchecked Sendable, Codable, JSONEncodable {
    public var reason: String?

    public init(reason: String? = nil) {
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case reason
    }
}

extension FlagUserOptions: Hashable {
    public static func == (lhs: FlagUserOptions, rhs: FlagUserOptions) -> Bool {
        lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(reason)
    }
}
