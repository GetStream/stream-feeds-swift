//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Websocket auth message
public final class WSAuthMessage: Sendable, Codable, JSONEncodable {
    /// List of products to subscribe to. One of: chat, video, feeds
    public let products: [String]?
    /// JWT token for authentication
    public let token: String
    public let userDetails: ConnectUserDetailsRequest

    public init(products: [String]? = nil, token: String, userDetails: ConnectUserDetailsRequest) {
        self.products = products
        self.token = token
        self.userDetails = userDetails
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.products = try container.decodeIfPresent([String].self, forKey: .products)
        self.token = try container.decode(String.self, forKey: .token)
        self.userDetails = try container.decode(ConnectUserDetailsRequest.self, forKey: .userDetails)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(products, forKey: .products)
        try container.encode(token, forKey: .token)
        try container.encode(userDetails, forKey: .userDetails)
    }
}

extension WSAuthMessage: Hashable {
    public static func == (lhs: WSAuthMessage, rhs: WSAuthMessage) -> Bool {
        lhs.products == rhs.products &&
            lhs.token == rhs.token &&
            lhs.userDetails == rhs.userDetails
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(products)
        hasher.combine(token)
        hasher.combine(userDetails)
    }
}
