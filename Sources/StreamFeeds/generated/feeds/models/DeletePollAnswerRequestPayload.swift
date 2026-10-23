//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for deleting the free-text poll answer a review item was raised for. Chat polls only. Deletion is permanent; the poll and other votes are kept.
public final class DeletePollAnswerRequestPayload: Sendable, Codable, JSONEncodable {
    /// Reason for deletion
    public let reason: String?

    public init(reason: String? = nil) {
        self.reason = reason
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(reason, forKey: .reason)
    }
}

extension DeletePollAnswerRequestPayload: Hashable {
    public static func == (lhs: DeletePollAnswerRequestPayload, rhs: DeletePollAnswerRequestPayload) -> Bool {
        lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(reason)
    }
}
