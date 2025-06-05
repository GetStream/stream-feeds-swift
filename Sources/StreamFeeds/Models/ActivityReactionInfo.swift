//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ActivityReactionInfo: Sendable {
    public let activityId: String
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let type: String
    public let updatedAt: Date
    public let user: UserResponse
    
    init(from response: FeedsReactionResponse) {
        self.activityId = response.activityId
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.type = response.type
        self.updatedAt = response.updatedAt
        self.user = response.user
    }
}

extension ActivityReactionInfo: Identifiable {
    public var id: String {
        activityId + user.id
    }
}
