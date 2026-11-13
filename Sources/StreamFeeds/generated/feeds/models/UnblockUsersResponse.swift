//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UnblockUsersResponse: Sendable, Decodable {
    public init() {}
}

extension UnblockUsersResponse: Hashable {
    public static func == (lhs: UnblockUsersResponse, rhs: UnblockUsersResponse) -> Bool {
        true
    }

    public func hash(into hasher: inout Hasher) {}
}
