//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateFeedMembersRequestOperation: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let remove = UpdateFeedMembersRequestOperation(rawValue: "remove")
    public static let set = UpdateFeedMembersRequestOperation(rawValue: "set")
    public static let upsert = UpdateFeedMembersRequestOperation(rawValue: "upsert")
}

public final class UpdateFeedMembersRequest: Sendable, Encodable, JSONEncodable {
    public let limit: Int?
    /// List of members to upsert, remove, or set
    public let members: [FeedMemberRequest]?
    public let next: String?
    /// Type of update operation to perform. One of: upsert, remove, set
    public let operation: UpdateFeedMembersRequestOperation
    public let prev: String?

    public init(limit: Int? = nil, members: [FeedMemberRequest]? = nil, next: String? = nil, operation: UpdateFeedMembersRequestOperation, prev: String? = nil) {
        self.limit = limit
        self.members = members
        self.next = next
        self.operation = operation
        self.prev = prev
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(members, forKey: .members)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encode(operation, forKey: .operation)
        try container.encodeIfPresent(prev, forKey: .prev)
    }
}

extension UpdateFeedMembersRequest: Hashable {
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
