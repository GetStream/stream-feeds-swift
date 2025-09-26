//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedsReactionData: Equatable, Sendable {
    public let activityId: String
    public let commentId: String?
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let type: String
    public let updatedAt: Date
    public private(set) var user: UserData
}

extension FeedsReactionData: Identifiable {
    public var id: String {
        "\(user.id)-\(type)-\(activityId)"
    }
}

// MARK: - Mutating the Data

extension FeedsReactionData {
    static func updateByAdding(
        reaction: FeedsReactionData,
        to latestReactions: inout [FeedsReactionData],
        reactionGroups: inout [String: ReactionGroupData]
    ) {
        guard latestReactions.insert(byId: reaction) else { return }
        var reactionGroup = reactionGroups[reaction.type] ?? ReactionGroupData(count: 1, firstReactionAt: reaction.createdAt, lastReactionAt: reaction.createdAt, sumScores: nil)
        reactionGroup.increment(with: reaction.createdAt)
        reactionGroups[reaction.type] = reactionGroup
    }
    
    static func updateByRemoving(
        reaction: FeedsReactionData,
        from latestReactions: inout [FeedsReactionData],
        reactionGroups: inout [String: ReactionGroupData]
    ) {
        guard latestReactions.remove(byId: reaction.id) else { return }
        if var reactionGroup = reactionGroups[reaction.type] {
            reactionGroup.decrement(with: reaction.createdAt)
            if !reactionGroup.isEmpty {
                reactionGroups[reaction.type] = reactionGroup
            } else {
                reactionGroups.removeValue(forKey: reaction.type)
            }
        }
    }
    
    mutating func updateUser(_ incomingData: UserData) {
        user = incomingData
    }
}

// MARK: - Model Conversions

extension FeedsReactionResponse {
    func toModel() -> FeedsReactionData {
        FeedsReactionData(
            activityId: activityId,
            commentId: commentId,
            createdAt: createdAt,
            custom: custom,
            type: type,
            updatedAt: updatedAt,
            user: user.toModel()
        )
    }
}
