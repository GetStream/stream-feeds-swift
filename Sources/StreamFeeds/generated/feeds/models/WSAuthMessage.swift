//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Websocket auth message
public final class WSAuthMessage: @unchecked Sendable, Codable, JSONEncodable {
    /// Realtime event protocol version. 3 omits channel.members from channel.updated, member.*, notification.message_new and notification.added_to_channel of channels with more than 100 members and sets members_included:false. Values above the newest supported version negotiate down to it.
    public var eventProtocol: Int?
    /// Channel-member custom keys to project onto message.member for messages this connection receives (opt-in; capped, off by default).
    public var memberCustomInclude: [String]?
    /// List of products to subscribe to. One of: chat, video, feeds
    public var products: [String]?
    /// JWT token for authentication
    public var token: String
    public var userDetails: ConnectUserDetailsRequest

    public init(
        eventProtocol: Int? = nil,
        memberCustomInclude: [String]? = nil,
        products: [String]? = nil,
        token: String,
        userDetails: ConnectUserDetailsRequest
    ) {
        self.eventProtocol = eventProtocol
        self.memberCustomInclude = memberCustomInclude
        self.products = products
        self.token = token
        self.userDetails = userDetails
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case eventProtocol = "event_protocol"
        case memberCustomInclude = "member_custom_include"
        case products
        case token
        case userDetails = "user_details"
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
