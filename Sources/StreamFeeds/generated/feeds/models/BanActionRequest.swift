import Foundation
import StreamCore

public final class BanActionRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum string: String, Sendable, Codable, CaseIterable {
        case hard
        case pruning
        case soft
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

    public var channelBanOnly: Bool?
    public var deleteMessages: String?
    public var ipBan: Bool?
    public var reason: String?
    public var shadow: Bool?
    public var timeout: Int?

    public init(channelBanOnly: Bool? = nil, deleteMessages: String? = nil, ipBan: Bool? = nil, reason: String? = nil, shadow: Bool? = nil, timeout: Int? = nil) {
        self.channelBanOnly = channelBanOnly
        self.deleteMessages = deleteMessages
        self.ipBan = ipBan
        self.reason = reason
        self.shadow = shadow
        self.timeout = timeout
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case channelBanOnly = "channel_ban_only"
        case deleteMessages = "delete_messages"
        case ipBan = "ip_ban"
        case reason
        case shadow
        case timeout
    }

    public static func == (lhs: BanActionRequest, rhs: BanActionRequest) -> Bool {
        lhs.channelBanOnly == rhs.channelBanOnly &&
            lhs.deleteMessages == rhs.deleteMessages &&
            lhs.ipBan == rhs.ipBan &&
            lhs.reason == rhs.reason &&
            lhs.shadow == rhs.shadow &&
            lhs.timeout == rhs.timeout
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(channelBanOnly)
        hasher.combine(deleteMessages)
        hasher.combine(ipBan)
        hasher.combine(reason)
        hasher.combine(shadow)
        hasher.combine(timeout)
    }
}
