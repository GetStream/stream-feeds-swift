import Foundation
import StreamCore

public final class UpdateFeedMembersRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum string: String, Sendable, Codable, CaseIterable {
        case add
        case remove
        case set
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue)
            {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var limit: Int?
    public var members: [FeedMemberPayload]?
    public var next: String?
    public var operation: String
    public var prev: String?

    public init(limit: Int? = nil, members: [FeedMemberPayload]? = nil, next: String? = nil, operation: String, prev: String? = nil) {
        self.limit = limit
        self.members = members
        self.next = next
        self.operation = operation
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case limit
        case members
        case next
        case operation
        case prev
    }

    public static func == (lhs: UpdateFeedMembersRequest, rhs: UpdateFeedMembersRequest) -> Bool {
        lhs.limit == rhs.limit &&
            lhs.members == rhs.members &&
            lhs.next == rhs.next &&
            lhs.operation == rhs.operation &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(limit)
        hasher.combine(members)
        hasher.combine(next)
        hasher.combine(operation)
        hasher.combine(prev)
    }
}
