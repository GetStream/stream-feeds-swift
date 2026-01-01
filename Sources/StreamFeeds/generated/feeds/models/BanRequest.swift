//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BanRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum BanRequestDeleteMessages: String, Sendable, Codable, CaseIterable {
        case hard
        case pruning
        case soft
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var bannedBy: UserRequest?
    public var bannedById: String?
    public var channelCid: String?
    public var deleteMessages: BanRequestDeleteMessages?
    public var ipBan: Bool?
    public var reason: String?
    public var shadow: Bool?
    public var targetUserId: String
    public var timeout: Int?

    public init(bannedBy: UserRequest? = nil, bannedById: String? = nil, channelCid: String? = nil, deleteMessages: BanRequestDeleteMessages? = nil, ipBan: Bool? = nil, reason: String? = nil, shadow: Bool? = nil, targetUserId: String, timeout: Int? = nil) {
        self.bannedBy = bannedBy
        self.bannedById = bannedById
        self.channelCid = channelCid
        self.deleteMessages = deleteMessages
        self.ipBan = ipBan
        self.reason = reason
        self.shadow = shadow
        self.targetUserId = targetUserId
        self.timeout = timeout
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bannedBy = "banned_by"
        case bannedById = "banned_by_id"
        case channelCid = "channel_cid"
        case deleteMessages = "delete_messages"
        case ipBan = "ip_ban"
        case reason
        case shadow
        case targetUserId = "target_user_id"
        case timeout
    }

    public static func == (lhs: BanRequest, rhs: BanRequest) -> Bool {
        lhs.bannedBy == rhs.bannedBy &&
            lhs.bannedById == rhs.bannedById &&
            lhs.channelCid == rhs.channelCid &&
            lhs.deleteMessages == rhs.deleteMessages &&
            lhs.ipBan == rhs.ipBan &&
            lhs.reason == rhs.reason &&
            lhs.shadow == rhs.shadow &&
            lhs.targetUserId == rhs.targetUserId &&
            lhs.timeout == rhs.timeout
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bannedBy)
        hasher.combine(bannedById)
        hasher.combine(channelCid)
        hasher.combine(deleteMessages)
        hasher.combine(ipBan)
        hasher.combine(reason)
        hasher.combine(shadow)
        hasher.combine(targetUserId)
        hasher.combine(timeout)
    }
}
