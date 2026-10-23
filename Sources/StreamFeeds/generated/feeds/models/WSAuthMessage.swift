//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Websocket auth message
public final class WSAuthMessage: Sendable, Codable, JSONEncodable {
    /// Realtime event protocol version. 3 omits channel.members from channel.updated, member.*, notification.message_new and notification.added_to_channel of channels with more than 100 members and sets members_included:false. Values above the newest supported version negotiate down to it.
    public let eventProtocol: Int?
    /// Channel-member custom keys to project onto message.member for messages this connection receives (opt-in; capped, off by default).
    public let memberCustomInclude: [String]?
    /// List of products to subscribe to. One of: chat, video, feeds
    public let products: [String]?
    /// JWT token for authentication
    public let token: String
    public let userDetails: ConnectUserDetailsRequest

    public init(eventProtocol: Int? = nil, memberCustomInclude: [String]? = nil, products: [String]? = nil, token: String, userDetails: ConnectUserDetailsRequest) {
        self.eventProtocol = eventProtocol
        self.memberCustomInclude = memberCustomInclude
        self.products = products
        self.token = token
        self.userDetails = userDetails
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.eventProtocol = try container.decodeIfPresent(Int.self, forKey: .eventProtocol)
        self.memberCustomInclude = try container.decodeIfPresent([String].self, forKey: .memberCustomInclude)
        self.products = try container.decodeIfPresent([String].self, forKey: .products)
        self.token = try container.decode(String.self, forKey: .token)
        self.userDetails = try container.decode(ConnectUserDetailsRequest.self, forKey: .userDetails)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(eventProtocol, forKey: .eventProtocol)
        try container.encodeIfPresent(memberCustomInclude, forKey: .memberCustomInclude)
        try container.encodeIfPresent(products, forKey: .products)
        try container.encode(token, forKey: .token)
        try container.encode(userDetails, forKey: .userDetails)
    }
}

extension WSAuthMessage: Hashable {
    public static func == (lhs: WSAuthMessage, rhs: WSAuthMessage) -> Bool {
        lhs.eventProtocol == rhs.eventProtocol &&
            lhs.memberCustomInclude == rhs.memberCustomInclude &&
            lhs.products == rhs.products &&
            lhs.token == rhs.token &&
            lhs.userDetails == rhs.userDetails
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(eventProtocol)
        hasher.combine(memberCustomInclude)
        hasher.combine(products)
        hasher.combine(token)
        hasher.combine(userDetails)
    }
}
