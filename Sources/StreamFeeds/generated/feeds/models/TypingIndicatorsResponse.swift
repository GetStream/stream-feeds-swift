//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The settings for typing indicator events.
public final class TypingIndicatorsResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var enabled: Bool

    public init(enabled: Bool) {
        self.enabled = enabled
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enabled
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
