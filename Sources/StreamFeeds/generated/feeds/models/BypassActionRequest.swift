//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BypassActionRequest: @unchecked Sendable, Codable, JSONEncodable {
    public var enabled: Bool?

    public init(enabled: Bool? = nil) {
        self.enabled = enabled
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enabled
    }
}

extension BypassActionRequest: Hashable {
    public static func == (lhs: BypassActionRequest, rhs: BypassActionRequest) -> Bool {
        lhs.enabled == rhs.enabled
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enabled)
    }
}
