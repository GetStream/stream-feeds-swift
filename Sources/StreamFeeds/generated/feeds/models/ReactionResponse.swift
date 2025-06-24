import Foundation
import StreamCore

public final class ReactionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var messageId: String
    public var score: Int
    public var type: String
    public var updatedAt: Date
    public var user: UserResponse
    public var userId: String

    public init(createdAt: Date, custom: [String: RawJSON], messageId: String, score: Int, type: String, updatedAt: Date, user: UserResponse, userId: String) {
        self.createdAt = createdAt
        self.custom = custom
        self.messageId = messageId
        self.score = score
        self.type = type
        self.updatedAt = updatedAt
        self.user = user
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case messageId = "message_id"
        case score
        case type
        case updatedAt = "updated_at"
        case user
        case userId = "user_id"
    }

    public static func == (lhs: ReactionResponse, rhs: ReactionResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.messageId == rhs.messageId &&
            lhs.score == rhs.score &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(messageId)
        hasher.combine(score)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
