//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IntentConfigRequest: Sendable, Codable, JSONEncodable {
    /// Topics to classify conversation text against (max 20, labels must be unique)
    public let topics: [IntentTopicRequest]?

    public init(topics: [IntentTopicRequest]? = nil) {
        self.topics = topics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.topics = try container.decodeIfPresent([IntentTopicRequest].self, forKey: .topics)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(topics, forKey: .topics)
    }
}

extension IntentConfigRequest: Hashable {
    public static func == (lhs: IntentConfigRequest, rhs: IntentConfigRequest) -> Bool {
        lhs.topics == rhs.topics
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(topics)
    }
}
