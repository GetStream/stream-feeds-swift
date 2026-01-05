//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddFolderRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var name: String

    public init(custom: [String: RawJSON]? = nil, name: String) {
        self.custom = custom
        self.name = name
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case name
    }

    public static func == (lhs: AddFolderRequest, rhs: AddFolderRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(name)
    }
}
