//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A request for adding comment when interacting with ``Activity``.
public struct ActivityAddCommentRequest: Sendable {
    private let request: AddCommentRequest
    
    public init(
        attachments: [Attachment]? = nil,
        comment: String,
        custom: [String: RawJSON]? = nil,
        mentionedUserIds: [String]? = nil,
        parentId: String? = nil
    ) {
        request = AddCommentRequest(
            attachments: attachments,
            comment: comment,
            custom: custom,
            mentionedUserIds: mentionedUserIds,
            objectId: "",
            objectType: "activity",
            parentId: parentId
        )
    }
    
    func withActivityId(_ id: String) -> AddCommentRequest {
        request.objectId = id
        return request
    }
}
