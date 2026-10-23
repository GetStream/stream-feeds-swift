//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddBookmarkRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Custom data for the bookmark
    public var custom: [String: RawJSON]?
    /// ID of the folder to add the bookmark to
    public var folderId: String?
    public var newFolder: AddFolderRequest?

    public init(custom: [String: RawJSON]? = nil, folderId: String? = nil, newFolder: AddFolderRequest? = nil) {
        self.custom = custom
        self.folderId = folderId
        self.newFolder = newFolder
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case folderId = "folder_id"
        case newFolder = "new_folder"
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
