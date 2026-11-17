//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationBanResponse: Sendable, Decodable {
    public init() {}
}

extension ModerationBanResponse: Hashable {
    public static func == (lhs: ModerationBanResponse, rhs: ModerationBanResponse) -> Bool {
        true
    }

    public func hash(into hasher: inout Hasher) {}
}
