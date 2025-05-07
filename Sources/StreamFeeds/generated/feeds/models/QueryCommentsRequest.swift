import Foundation
import StreamCore

public final class QueryCommentsRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum string: String, Sendable, Codable, CaseIterable {
        case first
        case last
        case reactionCount = "reaction_count"
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

    public var activityIds: [String]?
    public var limit: Int?
    public var next: String?
    public var parentIds: [String]?
    public var prev: String?
    public var sort: String?
    public var userId: String?

    public init(activityIds: [String]? = nil, limit: Int? = nil, next: String? = nil, parentIds: [String]? = nil, prev: String? = nil, sort: String? = nil, userId: String? = nil) {
        self.activityIds = activityIds
        self.limit = limit
        self.next = next
        self.parentIds = parentIds
        self.prev = prev
        self.sort = sort
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityIds = "activity_ids"
        case limit
        case next
        case parentIds = "parent_ids"
        case prev
        case sort
        case userId = "user_id"
    }

    public static func == (lhs: QueryCommentsRequest, rhs: QueryCommentsRequest) -> Bool {
        lhs.activityIds == rhs.activityIds &&
            lhs.limit == rhs.limit &&
            lhs.next == rhs.next &&
            lhs.parentIds == rhs.parentIds &&
            lhs.prev == rhs.prev &&
            lhs.sort == rhs.sort &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityIds)
        hasher.combine(limit)
        hasher.combine(next)
        hasher.combine(parentIds)
        hasher.combine(prev)
        hasher.combine(sort)
        hasher.combine(userId)
    }
}
