//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Websocket auth message
public final class WSAuthMessage: @unchecked Sendable, Codable, JSONEncodable {
    /// List of products to subscribe to. One of: chat, video, feeds
    public var products: [String]?
    /// JWT token for authentication
    public var token: String
    public var userDetails: ConnectUserDetailsRequest

    public init(products: [String]? = nil, token: String, userDetails: ConnectUserDetailsRequest) {
        self.products = products
        self.token = token
        self.userDetails = userDetails
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case products
        case token
        case userDetails = "user_details"
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
