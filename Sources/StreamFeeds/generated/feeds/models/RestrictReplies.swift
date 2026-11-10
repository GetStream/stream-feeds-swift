//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Who is allowed to reply to an activity.
public final class RestrictReplies: RawRepresentable, Encodable, CustomStringConvertible, Hashable, Sendable {
    public let rawValue: String

    public var description: String { rawValue }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let everyone = RestrictReplies(rawValue: "everyone")
    public static let nobody = RestrictReplies(rawValue: "nobody")
    public static let peopleIFollow = RestrictReplies(rawValue: "people_i_follow")
}
