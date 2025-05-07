//
//  FlatFeed.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 7.5.25.
//

import Foundation
import StreamCore

public class FlatFeed {
    
    public let group: String
    public let id: String
    
    private let apiClient: DefaultAPI
    
    public internal(set) var state = FeedState()
    
    internal init(group: String, id: String, apiClient: DefaultAPI) {
        self.apiClient = apiClient
        self.group = group
        self.id = id
    }
    
    public func create(
        members: [FeedMemberPayload]? = nil,
        visibility: CreateFeedRequest.FeedVisibility? = nil,
        custom: [String: RawJSON]? = nil
    ) async throws -> CreateFeedResponse {
        let request = CreateFeedRequest(
            custom: custom,
            group: group,
            id: id,
            members: members,
            visibility: visibility
        )
        let response = try await apiClient.createFeed(createFeedRequest: request)
        state.update(from: response)
        return response
    }
}
