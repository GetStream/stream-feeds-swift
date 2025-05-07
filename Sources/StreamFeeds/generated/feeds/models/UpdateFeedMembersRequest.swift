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

    public var members: [FeedMemberPayload]?
    public var operation: String

    public init(members: [FeedMemberPayload]? = nil, operation: String) {
        self.members = members
        self.operation = operation
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case members
        case operation
    }

    public static func == (lhs: UpdateFeedMembersRequest, rhs: UpdateFeedMembersRequest) -> Bool {
        lhs.members == rhs.members &&
            lhs.operation == rhs.operation
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(members)
        hasher.combine(operation)
    }
}
