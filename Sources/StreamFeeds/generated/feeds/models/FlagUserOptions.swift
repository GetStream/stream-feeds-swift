//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FlagUserOptions: Sendable, Encodable, JSONEncodable {
    public let reason: String?

    public init(reason: String? = nil) {
        self.reason = reason
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(reason, forKey: .reason)
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
