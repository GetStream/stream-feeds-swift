//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CustomActionRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var id: String?
    public var options: [String: RawJSON]?

    public init(id: String? = nil, options: [String: RawJSON]? = nil) {
        self.id = id
        self.options = options
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case options
    }

    public static func == (lhs: CustomActionRequest, rhs: CustomActionRequest) -> Bool {
        lhs.id == rhs.id &&
            lhs.options == rhs.options
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(options)
    }
}
