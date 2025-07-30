//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserCreatedWithinParameters: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var maxAge: String?

    public init(maxAge: String? = nil) {
        self.maxAge = maxAge
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case maxAge = "max_age"
    }

    public static func == (lhs: UserCreatedWithinParameters, rhs: UserCreatedWithinParameters) -> Bool {
        lhs.maxAge == rhs.maxAge
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(maxAge)
    }
}
