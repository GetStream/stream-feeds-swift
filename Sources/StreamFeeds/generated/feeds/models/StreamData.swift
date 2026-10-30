//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class StreamData: Sendable, Decodable {
    public let id: String

    public init(id: String) {
        self.id = id
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.id = try container.decode(String.self, forKey: .id)
    }
}

extension StreamData: Hashable {
    public static func == (lhs: StreamData, rhs: StreamData) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
