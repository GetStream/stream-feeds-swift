//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IntentTopicRequest: Sendable, Codable, JSONEncodable {
    /// Optional description used in the classification prompt; the label alone is used when empty
    public let description: String?
    /// Unique topic label (e.g. purchase_intent)
    public let label: String

    public init(description: String? = nil, label: String) {
        self.description = description
        self.label = label
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.label = try container.decode(String.self, forKey: .label)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(label, forKey: .label)
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
