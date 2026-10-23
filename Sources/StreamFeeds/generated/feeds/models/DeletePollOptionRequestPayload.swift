//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for deleting the single poll option a review item was raised for. Deletion is permanent; the rest of the poll is kept.
public final class DeletePollOptionRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Option to delete. Required on an item for a whole poll (create or edit); defaults to the option an add_option / update_option item was raised for
    public var optionId: String?
    /// Reason for deletion
    public var reason: String?

    public init(optionId: String? = nil, reason: String? = nil) {
        self.optionId = optionId
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case optionId = "option_id"
        case reason
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
