//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class GetApplicationResponse: Sendable, Decodable {
    /// A type representing the app settings.
    public let app: AppResponseFields

    public init(app: AppResponseFields) {
        self.app = app
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.app = try container.decode(AppResponseFields.self, forKey: .app)
    }
}

extension GetApplicationResponse: Hashable {
    public static func == (lhs: GetApplicationResponse, rhs: GetApplicationResponse) -> Bool {
        lhs.app == rhs.app
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(app)
    }
}
