//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Who can see an activity.
public enum ActivityVisibility: String, Sendable, Codable, CaseIterable {
    case `private`
    case `public`
    case tag
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = ActivityVisibility(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
