//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class GetApplicationResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// A type representing the app settings.
    public var app: AppResponseFields
    /// Duration of the request in milliseconds
    public var duration: String

    public init(app: AppResponseFields, duration: String) {
        self.app = app
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case app
        case duration
    }
}

extension GetApplicationResponse: Hashable {
    public static func == (lhs: GetApplicationResponse, rhs: GetApplicationResponse) -> Bool {
        lhs.app == rhs.app &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(app)
        hasher.combine(duration)
    }
}
