//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The settings for the delivery receipt events.
public final class DeliveryReceiptsResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var enabled: Bool

    public init(enabled: Bool) {
        self.enabled = enabled
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enabled
    }
}

extension DeliveryReceiptsResponse: Hashable {
    public static func == (lhs: DeliveryReceiptsResponse, rhs: DeliveryReceiptsResponse) -> Bool {
        lhs.enabled == rhs.enabled
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enabled)
    }
}
