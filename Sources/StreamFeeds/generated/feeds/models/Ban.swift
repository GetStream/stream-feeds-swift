import Foundation
import StreamCore

public final class Ban: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var createdBy: User?
    public var expires: Date?
    public var reason: String?
    public var shadow: Bool
    public var target: User?

    public init(createdAt: Date, createdBy: User? = nil, expires: Date? = nil, reason: String? = nil, shadow: Bool, target: User? = nil) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.expires = expires
        self.reason = reason
        self.shadow = shadow
        self.target = target
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case createdBy = "created_by"
        case expires
        case reason
        case shadow
        case target
    }

    public static func == (lhs: Ban, rhs: Ban) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.expires == rhs.expires &&
            lhs.reason == rhs.reason &&
            lhs.shadow == rhs.shadow &&
            lhs.target == rhs.target
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(expires)
        hasher.combine(reason)
        hasher.combine(shadow)
        hasher.combine(target)
    }
}
