//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PinActivityRequest: Sendable, Codable, JSONEncodable {
    /// If true, enriches the activity's current_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public let enrichOwnFields: Bool?

    public init(enrichOwnFields: Bool? = nil) {
        self.enrichOwnFields = enrichOwnFields
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.enrichOwnFields = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFields)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(enrichOwnFields, forKey: .enrichOwnFields)
    }
}

extension PinActivityRequest: Hashable {
    public static func == (lhs: PinActivityRequest, rhs: PinActivityRequest) -> Bool {
        lhs.enrichOwnFields == rhs.enrichOwnFields
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enrichOwnFields)
    }
}
