//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for custom moderation action
public final class CustomActionRequestPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Custom action identifier
    public var id: String?
    /// Custom action options
    public var options: [String: RawJSON]?

    public init(id: String? = nil, options: [String: RawJSON]? = nil) {
        self.id = id
        self.options = options
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case options
    }
}

extension CustomActionRequestPayload: Hashable {
    public static func == (lhs: CustomActionRequestPayload, rhs: CustomActionRequestPayload) -> Bool {
        lhs.id == rhs.id &&
            lhs.options == rhs.options
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(options)
    }
}
