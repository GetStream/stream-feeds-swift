//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedsReactionData: Sendable {
    public let activityId: String
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let type: String
    public let updatedAt: Date
    public let user: UserData
}

extension FeedsReactionData: Identifiable {
    public var id: String {
        activityId + user.id
    }
}

// MARK: - Mutating the Data

extension FeedsReactionData {
    static func updateByAdding(
        reaction: FeedsReactionData,
        to latestReactions: inout [FeedsReactionData],
        reactionGroups: inout [String: ReactionGroupData]
    ) {
        latestReactions.insert(byId: reaction)
        var reactionGroup = reactionGroups[reaction.type] ?? ReactionGroupData(count: 1, firstReactionAt: reaction.createdAt, lastReactionAt: reaction.createdAt)
        reactionGroup.increment(with: reaction.createdAt)
        reactionGroups[reaction.type] = reactionGroup
    }
    
    static func updateByRemoving(
        reaction: FeedsReactionData,
        from latestReactions: inout [FeedsReactionData],
        reactionGroups: inout [String: ReactionGroupData]
    ) {
        latestReactions.remove(byId: reaction.id)
        if var reactionGroup = reactionGroups[reaction.type] {
            reactionGroup.decrement(with: reaction.createdAt)
            if !reactionGroup.isEmpty {
                reactionGroups[reaction.type] = reactionGroup
            } else {
                reactionGroups.removeValue(forKey: reaction.type)
            }
        }
    }
}

// MARK: - Model Conversions

extension FeedsReactionResponse {
    func toModel() -> FeedsReactionData {
        FeedsReactionData(
            activityId: activityId,
            createdAt: createdAt,
            custom: custom,
            type: type,
            updatedAt: updatedAt,
            user: user.toModel()
        )
    }
}
