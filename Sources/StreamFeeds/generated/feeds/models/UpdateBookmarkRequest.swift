//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateBookmarkRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Custom data for the bookmark
    public var custom: [String: RawJSON]?
    /// ID of the folder containing the bookmark
    public var folderId: String?
    public var newFolder: AddFolderRequest?
    /// Move the bookmark to this folder (empty string removes the folder)
    public var newFolderId: String?

    public init(
        custom: [String: RawJSON]? = nil,
        folderId: String? = nil,
        newFolder: AddFolderRequest? = nil,
        newFolderId: String? = nil
    ) {
        self.custom = custom
        self.folderId = folderId
        self.newFolder = newFolder
        self.newFolderId = newFolderId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case folderId = "folder_id"
        case newFolder = "new_folder"
        case newFolderId = "new_folder_id"
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
