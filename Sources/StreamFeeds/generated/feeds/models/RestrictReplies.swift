//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Who is allowed to reply to an activity.
public enum RestrictReplies: String, Sendable, Codable, CaseIterable {
    case everyone
    case nobody
    case peopleIFollow = "people_i_follow"
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = RestrictReplies(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
