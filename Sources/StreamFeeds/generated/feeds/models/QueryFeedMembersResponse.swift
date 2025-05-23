import Foundation
import StreamCore

public final class QueryFeedMembersResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var members: [FeedMemberResponse]
    public var pagination: PagerResponse

    public init(duration: String, members: [FeedMemberResponse], pagination: PagerResponse) {
        self.duration = duration
        self.members = members
        self.pagination = pagination
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case members
        case pagination
    }

    public static func == (lhs: QueryFeedMembersResponse, rhs: QueryFeedMembersResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.members == rhs.members &&
            lhs.pagination == rhs.pagination
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(members)
        hasher.combine(pagination)
    }
}
