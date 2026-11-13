//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateCollectionsResponse: Sendable, Decodable {
    /// List of updated collections
    public let collections: [CollectionResponse]
    public let duration: String

    public init(collections: [CollectionResponse], duration: String) {
        self.collections = collections
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.collections = try container.decode([CollectionResponse].self, forKey: .collections)
        self.duration = try container.decode(String.self, forKey: .duration)
    }
}

extension UpdateCollectionsResponse: Hashable {
    public static func == (lhs: UpdateCollectionsResponse, rhs: UpdateCollectionsResponse) -> Bool {
        lhs.collections == rhs.collections &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(collections)
        hasher.combine(duration)
    }
}
