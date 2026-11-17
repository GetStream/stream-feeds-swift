//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBookmarkFolderRequest: Sendable, Encodable, JSONEncodable {
    /// Custom data for the folder
    public let custom: [String: RawJSON]?
    /// Name of the folder
    public let name: String?

    public init(custom: [String: RawJSON]? = nil, name: String? = nil) {
        self.custom = custom
        self.name = name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(name, forKey: .name)
    }
}

extension UpdateBookmarkFolderRequest: Hashable {
    public static func == (lhs: UpdateBookmarkFolderRequest, rhs: UpdateBookmarkFolderRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(name)
    }
}
