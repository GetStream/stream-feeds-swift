//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for reaction deletion action
public final class DeleteReactionRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Whether to permanently delete the reaction
    public var hardDelete: Bool?

    public init(hardDelete: Bool? = nil) {
        self.hardDelete = hardDelete
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case hardDelete = "hard_delete"
    }
}

extension DeleteReactionRequestPayload: Hashable {
    public static func == (lhs: DeleteReactionRequestPayload, rhs: DeleteReactionRequestPayload) -> Bool {
        lhs.hardDelete == rhs.hardDelete
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hardDelete)
    }
}
