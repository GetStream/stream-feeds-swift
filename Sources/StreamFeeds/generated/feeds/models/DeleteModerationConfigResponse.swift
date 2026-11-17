//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteModerationConfigResponse: Sendable, Decodable {
    public init() {}
}

extension DeleteModerationConfigResponse: Hashable {
    public static func == (lhs: DeleteModerationConfigResponse, rhs: DeleteModerationConfigResponse) -> Bool {
        true
    }

    public func hash(into hasher: inout Hasher) {}
}
