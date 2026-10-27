//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Whether a follow sends push notifications.
public enum FollowPushPreference: String, Sendable, Codable, CaseIterable {
    case all
    case none
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = FollowPushPreference(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
