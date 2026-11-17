//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class Response: Sendable, Decodable {
    public init() {}
}

extension Response: Hashable {
    public static func == (lhs: Response, rhs: Response) -> Bool {
        true
    }

    public func hash(into hasher: inout Hasher) {}
}
