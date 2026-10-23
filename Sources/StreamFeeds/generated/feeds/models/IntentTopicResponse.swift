//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IntentTopicResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Optional description used in the classification prompt; the label alone is used when empty
    public var description: String?
    /// Unique topic label (e.g. purchase_intent)
    public var label: String

    public init(description: String? = nil, label: String) {
        self.description = description
        self.label = label
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case description
        case label
    }
}

extension IntentTopicResponse: Hashable {
    public static func == (lhs: IntentTopicResponse, rhs: IntentTopicResponse) -> Bool {
        lhs.description == rhs.description &&
            lhs.label == rhs.label
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
        hasher.combine(label)
    }
}
