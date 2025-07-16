//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ActivityPinData: Equatable, Sendable {
    public internal(set) var activity: ActivityData
    public let createdAt: Date
    public let fid: FeedId
    public let updatedAt: Date
    public let userId: String
}

extension ActivityPinData: Identifiable {
    public var id: String {
        fid.rawValue + activity.id + userId
    }
}

// MARK: - Model Conversions

extension ActivityPinResponse {
    func toModel() -> ActivityPinData {
        ActivityPinData(
            activity: activity.toModel(),
            createdAt: createdAt,
            fid: FeedId(rawValue: feed),
            updatedAt: updatedAt,
            userId: user.id
        )
    }
}

extension PinActivityResponse {
    func toModel() -> ActivityPinData {
        ActivityPinData(
            activity: activity.toModel(),
            createdAt: createdAt,
            fid: FeedId(rawValue: fid),
            updatedAt: createdAt, // no updatedAt
            userId: userId
        )
    }
}
