import Foundation
import StreamCore

public final class FollowSuggestionsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var next: String?
    public var prev: String?
    public var suggestions: [Feed]

    public init(duration: String, next: String? = nil, prev: String? = nil, suggestions: [Feed]) {
        self.duration = duration
        self.next = next
        self.prev = prev
        self.suggestions = suggestions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case next
        case prev
        case suggestions
    }

    public static func == (lhs: FollowSuggestionsResponse, rhs: FollowSuggestionsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.suggestions == rhs.suggestions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(suggestions)
    }
}
