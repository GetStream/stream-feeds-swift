//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A request for adding activities when interacting with ``Feed``.
public struct FeedAddActivityRequest: Sendable {
    private let request: AddActivityRequest
    
    public init(
        attachments: [Attachment]? = nil,
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
        visibility: AddActivityRequest.ActivityVisibility? = nil,
        visibilityTag: String? = nil
    ) {
        request = AddActivityRequest(
            attachments: attachments,
            custom: custom,
            expiresAt: expiresAt,
            fids: [],
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
    
    func withFid(_ fid: FeedId) -> AddActivityRequest {
        request.fids = [fid.rawValue]
        return request
    }
}
