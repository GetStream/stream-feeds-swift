//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Membership status of a feed member.
public enum FeedMemberStatus: String, Sendable, Codable, CaseIterable {
    case member
    case pending
    case rejected
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = FeedMemberStatus(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
