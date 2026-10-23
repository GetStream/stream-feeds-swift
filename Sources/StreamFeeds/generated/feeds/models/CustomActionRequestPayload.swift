//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for custom moderation action
public final class CustomActionRequestPayload: Sendable, Codable, JSONEncodable {
    /// Custom action identifier
    public let id: String?
    /// Custom action options
    public let options: [String: RawJSON]?

    public init(id: String? = nil, options: [String: RawJSON]? = nil) {
        self.id = id
        self.options = options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.options = try container.decodeIfPresent([String: RawJSON].self, forKey: .options)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(options, forKey: .options)
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
