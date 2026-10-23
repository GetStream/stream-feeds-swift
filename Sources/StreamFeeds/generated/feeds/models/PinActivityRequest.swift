//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PinActivityRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// If true, enriches the activity's current_feed with own_* fields (own_follows, own_followings, own_capabilities, own_membership). Defaults to false for performance.
    public var enrichOwnFields: Bool?

    public init(enrichOwnFields: Bool? = nil) {
        self.enrichOwnFields = enrichOwnFields
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enrichOwnFields = "enrich_own_fields"
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
