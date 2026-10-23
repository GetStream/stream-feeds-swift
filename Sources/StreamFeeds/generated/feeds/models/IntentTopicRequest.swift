//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IntentTopicRequest: @unchecked Sendable, Codable, JSONEncodable {
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

extension IntentTopicRequest: Hashable {
    public static func == (lhs: IntentTopicRequest, rhs: IntentTopicRequest) -> Bool {
        lhs.description == rhs.description &&
            lhs.label == rhs.label
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
        hasher.combine(label)
    }
}
