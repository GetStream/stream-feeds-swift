//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddBookmarkRequest: Sendable, Encodable, JSONEncodable {
    /// Custom data for the bookmark
    public let custom: [String: RawJSON]?
    /// ID of the folder to add the bookmark to
    public let folderId: String?
    public let newFolder: AddFolderRequest?

    public init(custom: [String: RawJSON]? = nil, folderId: String? = nil, newFolder: AddFolderRequest? = nil) {
        self.custom = custom
        self.folderId = folderId
        self.newFolder = newFolder
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(folderId, forKey: .folderId)
        try container.encodeIfPresent(newFolder, forKey: .newFolder)
    }
}

extension AddBookmarkRequest: Hashable {
    public static func == (lhs: AddBookmarkRequest, rhs: AddBookmarkRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.folderId == rhs.folderId &&
            lhs.newFolder == rhs.newFolder
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(folderId)
        hasher.combine(newFolder)
    }
}
