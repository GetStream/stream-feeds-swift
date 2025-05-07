import Foundation
import StreamCore

public final class RejectFeedMemberRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var userId: String

    public init(userId: String) {
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case userId = "user_id"
    }

    public static func == (lhs: RejectFeedMemberRequest, rhs: RejectFeedMemberRequest) -> Bool {
        lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
}
