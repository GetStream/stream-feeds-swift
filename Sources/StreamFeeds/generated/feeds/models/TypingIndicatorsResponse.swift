//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The settings for typing indicator events.
public final class TypingIndicatorsResponse: Sendable, Codable, JSONEncodable {
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

extension TypingIndicatorsResponse: Hashable {
    public static func == (lhs: TypingIndicatorsResponse, rhs: TypingIndicatorsResponse) -> Bool {
        lhs.enabled == rhs.enabled
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enabled)
    }
}
