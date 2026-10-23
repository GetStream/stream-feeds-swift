//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The settings for the delivery receipt events.
public final class DeliveryReceiptsResponse: Sendable, Codable, JSONEncodable {
    public let enabled: Bool

    public init(enabled: Bool) {
        self.enabled = enabled
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(enabled, forKey: .enabled)
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
