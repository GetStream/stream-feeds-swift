import Foundation
import StreamCore

public final class UpdateBookmarkRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var folderId: String?
    public var newFolder: AddFolderRequest?
    public var newFolderId: String?

    public init(custom: [String: RawJSON]? = nil, folderId: String? = nil, newFolder: AddFolderRequest? = nil, newFolderId: String? = nil) {
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
