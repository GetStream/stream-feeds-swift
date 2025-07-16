//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ReactionGroupData: Equatable, Sendable {
    public private(set) var count: Int
    public let firstReactionAt: Date
    public private(set) var lastReactionAt: Date
}

extension ReactionGroupData {
    var isEmpty: Bool { count <= 0 }
    
    mutating func decrement(with date: Date) {
        guard date >= firstReactionAt || date <= lastReactionAt else { return }
        count = max(0, count - 1)
    }
    
    mutating func increment(with date: Date) {
        guard date > firstReactionAt else { return }
        count += 1
        lastReactionAt = date
    }
}

// MARK: - Model Conversions

extension ReactionGroupResponse {
    func toModel() -> ReactionGroupData {
        ReactionGroupData(
            count: count,
            firstReactionAt: firstReactionAt,
            lastReactionAt: lastReactionAt
        )
    }
}
