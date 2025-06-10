//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedMemberData: Sendable {
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let requestAcceptedAt: Date?
    public let requestRejectedAt: Date?
    public let role: String
    public let status: String
    public let updatedAt: Date
    public let user: UserData
    
    init(from response: FeedMemberResponse) {
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.requestAcceptedAt = response.inviteAcceptedAt
        self.requestRejectedAt = response.inviteRejectedAt
        self.role = response.role
        self.status = response.status
        self.updatedAt = response.updatedAt
        self.user = UserData(from: response.user)
    }
}

extension FeedMemberData: Identifiable {
    public var id: String {
        user.id
    }
}
