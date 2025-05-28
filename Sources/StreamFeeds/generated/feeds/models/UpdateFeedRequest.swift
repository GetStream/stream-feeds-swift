import Foundation
import StreamCore

public final class UpdateFeedRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdById: String?
    public var custom: [String: RawJSON]?

    public init(createdById: String? = nil, custom: [String: RawJSON]? = nil) {
        self.createdById = createdById
        self.custom = custom
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdById = "created_by_id"
        case custom
    }

    public static func == (lhs: UpdateFeedRequest, rhs: UpdateFeedRequest) -> Bool {
        lhs.createdById == rhs.createdById &&
            lhs.custom == rhs.custom
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdById)
        hasher.combine(custom)
    }
}
