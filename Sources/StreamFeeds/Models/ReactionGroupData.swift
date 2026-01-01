//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ReactionGroupData: Equatable, Sendable {
    public private(set) var count: Int
    public let firstReactionAt: Date
    public private(set) var lastReactionAt: Date
    public let sumScores: Int?
}

// MARK: - Model Conversions

extension ReactionGroupResponse {
    func toModel() -> ReactionGroupData {
        ReactionGroupData(
            count: count,
            firstReactionAt: firstReactionAt,
            lastReactionAt: lastReactionAt,
            sumScores: sumScores
        )
    }
}
