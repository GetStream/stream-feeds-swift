//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteActivityResponse: Sendable, Decodable {
    public init() {}
}

extension DeleteActivityResponse: Hashable {
    public static func == (lhs: DeleteActivityResponse, rhs: DeleteActivityResponse) -> Bool {
        true
    }

    public func hash(into hasher: inout Hasher) {}
}
