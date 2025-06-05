//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedMemberInfo: Sendable {
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let request: Bool?
    public let requestAcceptedAt: Date?
    public let requestRejectedAt: Date?
    public let role: String
    public let status: String
    public let updatedAt: Date
    public let user: UserResponse
    
    init(from response: FeedMemberResponse) {
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.request = response.request
        self.requestAcceptedAt = response.requestAcceptedAt
        self.requestRejectedAt = response.requestRejectedAt
        self.role = response.role
        self.status = response.status
        self.updatedAt = response.updatedAt
        self.user = response.user
    }
} 
