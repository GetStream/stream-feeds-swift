//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserCreatedWithinParameters: Sendable, Codable, JSONEncodable {
    public let maxAge: String?

    public init(maxAge: String? = nil) {
        self.maxAge = maxAge
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.maxAge = try container.decodeIfPresent(String.self, forKey: .maxAge)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(maxAge, forKey: .maxAge)
    }
}

extension UserCreatedWithinParameters: Hashable {
    public static func == (lhs: UserCreatedWithinParameters, rhs: UserCreatedWithinParameters) -> Bool {
        lhs.maxAge == rhs.maxAge
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(maxAge)
    }
}
