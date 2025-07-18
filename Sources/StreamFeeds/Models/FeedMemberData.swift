//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedMemberData: Equatable, Sendable {
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let inviteAcceptedAt: Date?
    public let inviteRejectedAt: Date?
    public let role: String
    public let status: FeedMemberStatus
    public let updatedAt: Date
    public let user: UserData
}

public typealias FeedMemberStatus = FeedMemberResponse.FeedMemberResponseStatus

extension FeedMemberData: Identifiable {
    public var id: String {
        user.id
    }
}

// MARK: - Model Conversions

extension FeedMemberResponse {
    func toModel() -> FeedMemberData {
        FeedMemberData(
            createdAt: createdAt,
            custom: custom,
            inviteAcceptedAt: inviteAcceptedAt,
            inviteRejectedAt: inviteRejectedAt,
            role: role,
            status: status,
            updatedAt: updatedAt,
            user: user.toModel()
        )
    }
}
