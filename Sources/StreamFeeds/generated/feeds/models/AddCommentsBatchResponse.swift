import Foundation
import StreamCore

public final class AddCommentsBatchResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comments: [Comment]
    public var duration: String

    public init(comments: [Comment], duration: String) {
        self.comments = comments
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comments
        case duration
    }

    public static func == (lhs: AddCommentsBatchResponse, rhs: AddCommentsBatchResponse) -> Bool {
        lhs.comments == rhs.comments &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
        hasher.combine(duration)
    }
}
