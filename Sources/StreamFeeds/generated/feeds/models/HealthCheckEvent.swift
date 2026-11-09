//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class HealthCheckEvent: Sendable, Event, Decodable {
    public let cid: String?
    public let connectionId: String
    public let createdAt: Date
    public let me: OwnUserResponse?
    public let receivedAt: Date?
    public let type: String

    public init(cid: String? = nil, connectionId: String, createdAt: Date, me: OwnUserResponse? = nil, receivedAt: Date? = nil, type: String = "health.check") {
        self.cid = cid
        self.connectionId = connectionId
        self.createdAt = createdAt
        self.me = me
        self.receivedAt = receivedAt
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.cid = try container.decodeIfPresent(String.self, forKey: .cid)
        self.connectionId = try container.decode(String.self, forKey: .connectionId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.me = try container.decodeIfPresent(OwnUserResponse.self, forKey: .me)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
    }
}

extension HealthCheckEvent: Hashable {
    public static func == (lhs: HealthCheckEvent, rhs: HealthCheckEvent) -> Bool {
        lhs.cid == rhs.cid &&
            lhs.connectionId == rhs.connectionId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.me == rhs.me &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(cid)
        hasher.combine(connectionId)
        hasher.combine(createdAt)
        hasher.combine(me)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
