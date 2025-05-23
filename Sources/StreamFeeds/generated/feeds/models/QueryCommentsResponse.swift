import Foundation
import StreamCore

public final class QueryCommentsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var comments: [CommentResponse]
    public var duration: String
    public var next: String?
    public var prev: String?

    public init(comments: [CommentResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.comments = comments
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comments
        case duration
        case next
        case prev
    }

    public static func == (lhs: QueryCommentsResponse, rhs: QueryCommentsResponse) -> Bool {
        lhs.comments == rhs.comments &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
