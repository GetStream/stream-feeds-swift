//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ReactionGroupData: Sendable {
    public private(set) var count: Int
    public let firstReactionAt: Date
    public private(set) var lastReactionAt: Date
}

extension ReactionGroupData {
    init(from response: ReactionGroupResponse) {
        self.count = response.count
        self.firstReactionAt = response.firstReactionAt
        self.lastReactionAt = response.lastReactionAt
    }
    
    mutating func increment(with date: Date) {
        count += 1
        lastReactionAt = date
    }
}
