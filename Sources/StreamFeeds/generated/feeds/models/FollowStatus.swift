//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Status of a follow request.
public enum FollowStatus: String, Sendable, Codable, CaseIterable {
    case accepted
    case pending
    case rejected
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = FollowStatus(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
