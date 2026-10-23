//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IntentConfigResponse: Sendable, Codable, JSONEncodable {
    /// Topics conversation text is classified against
    public let topics: [IntentTopicResponse]

    public init(topics: [IntentTopicResponse]) {
        self.topics = topics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.topics = try container.decode([IntentTopicResponse].self, forKey: .topics)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(topics, forKey: .topics)
    }
}

extension IntentConfigResponse: Hashable {
    public static func == (lhs: IntentConfigResponse, rhs: IntentConfigResponse) -> Bool {
        lhs.topics == rhs.topics
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(topics)
    }
}
