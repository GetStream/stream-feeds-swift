import Foundation
import StreamCore

public final class RemoveCommentResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
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

    public static func == (lhs: RemoveCommentResponse, rhs: RemoveCommentResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(duration)
    }
}
