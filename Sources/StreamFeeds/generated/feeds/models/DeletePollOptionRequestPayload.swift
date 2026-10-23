//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for deleting the single poll option a review item was raised for. Deletion is permanent; the rest of the poll is kept.
public final class DeletePollOptionRequestPayload: Sendable, Codable, JSONEncodable {
    /// Option to delete. Required on an item for a whole poll (create or edit); defaults to the option an add_option / update_option item was raised for
    public let optionId: String?
    /// Reason for deletion
    public let reason: String?

    public init(optionId: String? = nil, reason: String? = nil) {
        self.optionId = optionId
        self.reason = reason
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.optionId = try container.decodeIfPresent(String.self, forKey: .optionId)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(optionId, forKey: .optionId)
        try container.encodeIfPresent(reason, forKey: .reason)
    }
}

extension DeletePollOptionRequestPayload: Hashable {
    public static func == (lhs: DeletePollOptionRequestPayload, rhs: DeletePollOptionRequestPayload) -> Bool {
        lhs.optionId == rhs.optionId &&
            lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(optionId)
        hasher.combine(reason)
    }
}
