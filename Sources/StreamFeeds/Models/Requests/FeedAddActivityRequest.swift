//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A request for adding activities when interacting with ``Feed``.
public struct FeedAddActivityRequest: Sendable {
    private let request: AddActivityRequest
    let attachmentUploads: [AnyAttachmentPayload]?
    
    public init(
        attachments: [Attachment]? = nil,
        attachmentUploads: [AnyAttachmentPayload]? = nil,
        custom: [String: RawJSON]? = nil,
        expiresAt: String? = nil,
        filterTags: [String]? = nil,
        id: String? = nil,
        interestTags: [String]? = nil,
        location: ActivityLocation? = nil,
        mentionedUserIds: [String]? = nil,
        parentId: String? = nil,
        pollId: String? = nil,
        searchData: [String: RawJSON]? = nil,
        text: String? = nil,
        type: String,
        visibility: AddActivityRequest.AddActivityRequestVisibility? = nil,
        visibilityTag: String? = nil
    ) {
        self.attachmentUploads = attachmentUploads
        request = AddActivityRequest(
            attachments: attachments,
            custom: custom,
            expiresAt: expiresAt,
            feedIds: [],
            filterTags: filterTags,
            id: id,
            interestTags: interestTags,
            location: location,
            mentionedUserIds: mentionedUserIds,
            parentId: parentId,
            pollId: pollId,
            searchData: searchData,
            text: text,
            type: type,
            visibility: visibility,
            visibilityTag: visibilityTag
        )
    }
    
    var fidString: String? { request.feedIds.first }
    
    func withFid(_ fid: FeedId, uploadedAttachments: [Attachment]) -> AddActivityRequest {
        request.feedIds = [fid.rawValue]
        
        let attachments = (request.attachments ?? []) + uploadedAttachments
        request.attachments = attachments.isEmpty ? nil : attachments
        return request
    }
}
