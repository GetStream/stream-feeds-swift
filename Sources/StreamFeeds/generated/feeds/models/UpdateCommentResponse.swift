import Foundation
import StreamCore

public final class UpdateCommentResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comment: Comment
    public var duration: String

    public init(comment: Comment, duration: String) {
        self.comment = comment
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case duration
    }

    public static func == (lhs: UpdateCommentResponse, rhs: UpdateCommentResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(duration)
    }
}
