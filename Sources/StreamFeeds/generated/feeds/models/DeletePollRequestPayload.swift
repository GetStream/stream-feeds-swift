//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for poll deletion action. Poll deletion is always permanent.
public final class DeletePollRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Reason for deletion
    public var reason: String?

    public init(reason: String? = nil) {
        self.reason = reason
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case reason
    }
}

extension DeletePollRequestPayload: Hashable {
    public static func == (lhs: DeletePollRequestPayload, rhs: DeletePollRequestPayload) -> Bool {
        lhs.reason == rhs.reason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(reason)
    }
}
