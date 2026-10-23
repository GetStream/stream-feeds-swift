//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class GetApplicationResponse: Sendable, Codable, JSONEncodable {
    /// A type representing the app settings.
    public let app: AppResponseFields
    /// Duration of the request in milliseconds
    public let duration: String

    public init(app: AppResponseFields, duration: String) {
        self.app = app
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.app = try container.decode(AppResponseFields.self, forKey: .app)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(app, forKey: .app)
        try container.encode(duration, forKey: .duration)
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
