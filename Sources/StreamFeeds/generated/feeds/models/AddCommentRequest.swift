import Foundation
import StreamCore

public final class AddCommentRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var attachments: [Attachment]?
    public var comment: String
    public var custom: [String: RawJSON]?
    public var mentionedUserIds: [String]?
    public var objectId: String
    public var objectType: String
    public var parentId: String?

    public init(attachments: [Attachment]? = nil, comment: String, custom: [String: RawJSON]? = nil, mentionedUserIds: [String]? = nil, objectId: String, objectType: String, parentId: String? = nil) {
        self.attachments = attachments
        self.comment = comment
        self.custom = custom
        self.mentionedUserIds = mentionedUserIds
        self.objectId = objectId
        self.objectType = objectType
        self.parentId = parentId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case comment
        case custom
        case mentionedUserIds = "mentioned_user_ids"
        case objectId = "object_id"
        case objectType = "object_type"
        case parentId = "parent_id"
    }

    public static func == (lhs: AddCommentRequest, rhs: AddCommentRequest) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.comment == rhs.comment &&
            lhs.custom == rhs.custom &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.objectId == rhs.objectId &&
            lhs.objectType == rhs.objectType &&
            lhs.parentId == rhs.parentId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(comment)
        hasher.combine(custom)
        hasher.combine(mentionedUserIds)
        hasher.combine(objectId)
        hasher.combine(objectType)
        hasher.combine(parentId)
    }
}
