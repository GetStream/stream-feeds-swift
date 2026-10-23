//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddFolderRequest: Sendable, Encodable, JSONEncodable {
    /// Custom data for the folder
    public let custom: [String: RawJSON]?
    /// Name of the folder
    public let name: String

    public init(custom: [String: RawJSON]? = nil, name: String) {
        self.custom = custom
        self.name = name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(name, forKey: .name)
    }
}

extension AddFolderRequest: Hashable {
    public static func == (lhs: AddFolderRequest, rhs: AddFolderRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(name)
    }
}
