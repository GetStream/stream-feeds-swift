//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ReactionGroupData: Equatable, Sendable {
    public private(set) var count: Int
    public let firstReactionAt: Date
    public private(set) var lastReactionAt: Date
}

// MARK: - Model Conversions

extension FeedsReactionGroupResponse {
    func toModel() -> ReactionGroupData {
        ReactionGroupData(
            count: count,
            firstReactionAt: firstReactionAt,
            lastReactionAt: lastReactionAt
        )
    }
}
