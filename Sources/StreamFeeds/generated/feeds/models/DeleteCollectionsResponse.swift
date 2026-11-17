//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteCollectionsResponse: Sendable, Decodable {
    public init() {}
}

extension DeleteCollectionsResponse: Hashable {
    public static func == (lhs: DeleteCollectionsResponse, rhs: DeleteCollectionsResponse) -> Bool {
        true
    }

    public func hash(into hasher: inout Hasher) {}
}
