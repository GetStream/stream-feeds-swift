//
// Copyright © 2026 Stream.io Inc. All rights reserved.
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
        if let commentId {
            "\(user.id)-\(type)-\(commentId)-\(activityId)"
        } else {
            "\(user.id)-\(type)-\(activityId)"
        }
    }
}

// MARK: - Mutating the Data

extension FeedsReactionData {
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
