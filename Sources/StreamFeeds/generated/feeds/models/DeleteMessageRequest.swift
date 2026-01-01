//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteMessageRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var hardDelete: Bool?

    public init(hardDelete: Bool? = nil) {
        self.hardDelete = hardDelete
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case hardDelete = "hard_delete"
    }

    public static func == (lhs: DeleteMessageRequest, rhs: DeleteMessageRequest) -> Bool {
        lhs.hardDelete == rhs.hardDelete
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hardDelete)
    }
}
