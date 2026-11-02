//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for reaction deletion action
public final class DeleteReactionRequestPayload: Sendable, Encodable, JSONEncodable {
    /// Whether to permanently delete the reaction
    public let hardDelete: Bool?

    public init(hardDelete: Bool? = nil) {
        self.hardDelete = hardDelete
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(hardDelete, forKey: .hardDelete)
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
