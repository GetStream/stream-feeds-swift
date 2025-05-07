import Foundation
import StreamCore

public final class RemoveBookmarkResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var bookmark: Bookmark
    public var duration: String

    public init(bookmark: Bookmark, duration: String) {
        self.bookmark = bookmark
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bookmark
        case duration
    }

    public static func == (lhs: RemoveBookmarkResponse, rhs: RemoveBookmarkResponse) -> Bool {
        lhs.bookmark == rhs.bookmark &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmark)
        hasher.combine(duration)
    }
}
