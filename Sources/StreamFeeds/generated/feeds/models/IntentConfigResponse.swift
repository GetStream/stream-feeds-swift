//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IntentConfigResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Topics conversation text is classified against
    public var topics: [IntentTopicResponse]

    public init(topics: [IntentTopicResponse]) {
        self.topics = topics
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case topics
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
