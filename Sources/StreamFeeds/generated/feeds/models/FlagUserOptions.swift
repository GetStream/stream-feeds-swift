//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagUserOptions: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var reason: String

    public init(reason: String) {
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case reason
    }

    public static func == (lhs: FlagUserOptions, rhs: FlagUserOptions) -> Bool {
        lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(reason)
    }
}
