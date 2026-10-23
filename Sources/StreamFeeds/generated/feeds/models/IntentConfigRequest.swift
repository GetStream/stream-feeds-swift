//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class IntentConfigRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Topics to classify conversation text against (max 20, labels must be unique)
    public var topics: [IntentTopicRequest]?

    public init(topics: [IntentTopicRequest]? = nil) {
        self.topics = topics
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case topics
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
