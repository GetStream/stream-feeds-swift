import Foundation
import StreamCore

public final class AddBookmarkRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var custom: [String: RawJSON]?
    public var folderId: String?
    public var newFolder: AddFolderRequest?

    public init(activityId: String, custom: [String: RawJSON]? = nil, folderId: String? = nil, newFolder: AddFolderRequest? = nil) {
        self.activityId = activityId
        self.custom = custom
        self.folderId = folderId
        self.newFolder = newFolder
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case custom
        case folderId = "folder_id"
        case newFolder = "new_folder"
    }

    public static func == (lhs: AddBookmarkRequest, rhs: AddBookmarkRequest) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.custom == rhs.custom &&
            lhs.folderId == rhs.folderId &&
            lhs.newFolder == rhs.newFolder
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(custom)
        hasher.combine(folderId)
        hasher.combine(newFolder)
    }
}
