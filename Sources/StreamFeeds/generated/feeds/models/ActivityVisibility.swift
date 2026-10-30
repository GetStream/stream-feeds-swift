//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Who can see an activity.
public final class ActivityVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = ActivityVisibility(rawValue: "private")
    public static let `public` = ActivityVisibility(rawValue: "public")
    public static let tag = ActivityVisibility(rawValue: "tag")
}
