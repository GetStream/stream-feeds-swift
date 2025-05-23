import Foundation
import StreamCore

public final class BookmarkFolderResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var id: String
    public var name: String
    public var updatedAt: Date

    public init(createdAt: Date, custom: [String: RawJSON]? = nil, id: String, name: String, updatedAt: Date) {
        self.createdAt = createdAt
        self.custom = custom
        self.id = id
        self.name = name
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case id
        case name
        case updatedAt = "updated_at"
    }

    public static func == (lhs: BookmarkFolderResponse, rhs: BookmarkFolderResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(updatedAt)
    }
}
