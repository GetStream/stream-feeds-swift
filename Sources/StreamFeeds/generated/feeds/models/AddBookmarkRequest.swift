//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddBookmarkRequest: Sendable, Codable, JSONEncodable {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.folderId = try container.decodeIfPresent(String.self, forKey: .folderId)
        self.newFolder = try container.decodeIfPresent(AddFolderRequest.self, forKey: .newFolder)
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
