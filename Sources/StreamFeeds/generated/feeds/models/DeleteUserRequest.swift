import Foundation
import StreamCore

public final class DeleteUserRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var deleteConversationChannels: Bool?
    public var deleteFeedsContent: Bool?
    public var hardDelete: Bool?
    public var markMessagesDeleted: Bool?

    public init(deleteConversationChannels: Bool? = nil, deleteFeedsContent: Bool? = nil, hardDelete: Bool? = nil, markMessagesDeleted: Bool? = nil) {
        self.deleteConversationChannels = deleteConversationChannels
        self.deleteFeedsContent = deleteFeedsContent
        self.hardDelete = hardDelete
        self.markMessagesDeleted = markMessagesDeleted
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case deleteConversationChannels = "delete_conversation_channels"
        case deleteFeedsContent = "delete_feeds_content"
        case hardDelete = "hard_delete"
        case markMessagesDeleted = "mark_messages_deleted"
    }

    public static func == (lhs: DeleteUserRequest, rhs: DeleteUserRequest) -> Bool {
        lhs.deleteConversationChannels == rhs.deleteConversationChannels &&
            lhs.deleteFeedsContent == rhs.deleteFeedsContent &&
            lhs.hardDelete == rhs.hardDelete &&
            lhs.markMessagesDeleted == rhs.markMessagesDeleted
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(deleteConversationChannels)
        hasher.combine(deleteFeedsContent)
        hasher.combine(hardDelete)
        hasher.combine(markMessagesDeleted)
    }
}
