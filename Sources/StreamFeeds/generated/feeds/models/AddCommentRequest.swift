import Foundation
import StreamCore

public final class AddCommentRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comment: String
    public var custom: [String: RawJSON]?
    public var parentId: String?

    public init(comment: String, custom: [String: RawJSON]? = nil, parentId: String? = nil) {
        self.comment = comment
        self.custom = custom
        self.parentId = parentId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case custom
        case parentId = "parent_id"
    }

    public static func == (lhs: AddCommentRequest, rhs: AddCommentRequest) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.custom == rhs.custom &&
            lhs.parentId == rhs.parentId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(custom)
        hasher.combine(parentId)
    }
}
