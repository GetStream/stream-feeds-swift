//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for activity deletion action
public final class DeleteActivityRequestPayload: Sendable, Codable, JSONEncodable {
    /// Whether to permanently delete the activity
    public let hardDelete: Bool?

    public init(hardDelete: Bool? = nil) {
        self.hardDelete = hardDelete
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.hardDelete = try container.decodeIfPresent(Bool.self, forKey: .hardDelete)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(hardDelete, forKey: .hardDelete)
    }
}

extension DeleteActivityRequestPayload: Hashable {
    public static func == (lhs: DeleteActivityRequestPayload, rhs: DeleteActivityRequestPayload) -> Bool {
        lhs.hardDelete == rhs.hardDelete
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hardDelete)
    }
}
