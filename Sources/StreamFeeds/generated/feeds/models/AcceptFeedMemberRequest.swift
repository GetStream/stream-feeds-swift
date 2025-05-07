import Foundation
import StreamCore

public final class AcceptFeedMemberRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var userId: String

    public init(userId: String) {
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case userId = "user_id"
    }

    public static func == (lhs: AcceptFeedMemberRequest, rhs: AcceptFeedMemberRequest) -> Bool {
        lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
}
