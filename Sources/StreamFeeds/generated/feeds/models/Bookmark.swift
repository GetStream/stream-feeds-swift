import Foundation
import StreamCore

public final class Bookmark: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var folder: BookmarkFolder
    public var updatedAt: Date
    public var user: UserResponse

    public init(activityId: String, createdAt: Date, custom: [String: RawJSON]? = nil, folder: BookmarkFolder, updatedAt: Date, user: UserResponse) {
        self.activityId = activityId
        self.createdAt = createdAt
        self.custom = custom
        self.folder = folder
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case createdAt = "created_at"
        case custom
        case folder
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.folder == rhs.folder &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(folder)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
