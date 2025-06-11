import Foundation
import StreamCore

public final class ActivityPinResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var createdAt: Date
    public var feed: String
    public var updatedAt: Date
    public var user: UserResponse

    public init(activity: ActivityResponse, createdAt: Date, feed: String, updatedAt: Date, user: UserResponse) {
        self.activity = activity
        self.createdAt = createdAt
        self.feed = feed
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case createdAt = "created_at"
        case feed
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: ActivityPinResponse, rhs: ActivityPinResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.feed == rhs.feed &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(createdAt)
        hasher.combine(feed)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
