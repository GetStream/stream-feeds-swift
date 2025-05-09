import Foundation
import StreamCore

public final class PagerRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var limit: Int?
    public var next: String?
    public var prev: String?

    public init(limit: Int? = nil, next: String? = nil, prev: String? = nil) {
        self.limit = limit
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case limit
        case next
        case prev
    }

    public static func == (lhs: PagerRequest, rhs: PagerRequest) -> Bool {
        lhs.limit == rhs.limit &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(limit)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
