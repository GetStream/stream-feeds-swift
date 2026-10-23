//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBookmarkRequest: Sendable, Codable, JSONEncodable {
    /// Custom data for the bookmark
    public let custom: [String: RawJSON]?
    /// ID of the folder containing the bookmark
    public let folderId: String?
    public let newFolder: AddFolderRequest?
    /// Move the bookmark to this folder (empty string removes the folder)
    public let newFolderId: String?

    public init(custom: [String: RawJSON]? = nil, folderId: String? = nil, newFolder: AddFolderRequest? = nil, newFolderId: String? = nil) {
        self.custom = custom
        self.folderId = folderId
        self.newFolder = newFolder
        self.newFolderId = newFolderId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.folderId = try container.decodeIfPresent(String.self, forKey: .folderId)
        self.newFolder = try container.decodeIfPresent(AddFolderRequest.self, forKey: .newFolder)
        self.newFolderId = try container.decodeIfPresent(String.self, forKey: .newFolderId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(folderId, forKey: .folderId)
        try container.encodeIfPresent(newFolder, forKey: .newFolder)
        try container.encodeIfPresent(newFolderId, forKey: .newFolderId)
    }
}

extension UpdateBookmarkRequest: Hashable {
    public static func == (lhs: UpdateBookmarkRequest, rhs: UpdateBookmarkRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.folderId == rhs.folderId &&
            lhs.newFolder == rhs.newFolder &&
            lhs.newFolderId == rhs.newFolderId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(folderId)
        hasher.combine(newFolder)
        hasher.combine(newFolderId)
    }
}
