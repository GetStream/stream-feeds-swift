//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for deleting the free-text poll answer a review item was raised for. Chat polls only. Deletion is permanent; the poll and other votes are kept.
public final class DeletePollAnswerRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Reason for deletion
    public var reason: String?

    public init(reason: String? = nil) {
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case reason
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
