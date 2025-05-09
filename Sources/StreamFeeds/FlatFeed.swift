//
//  FlatFeed.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 7.5.25.
//

import Foundation
import StreamCore

public class FlatFeed: WSEventsSubscriber {
    
    public let group: String
    public let id: String
    
    var fid: String {
        "\(group):\(id)"
    }
    
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
            feedId: id,
            members: members,
            visibility: visibility
        )
        let response = try await apiClient.createFeed(feedGroupId: group, createFeedRequest: request)
        Task { @MainActor in
            state.update(from: response)
        }
        return response
    }
    
    public func get() async throws -> GetFeedResponse {
        let response = try await apiClient.getFeed(feedGroupId: group, feedId: id)
        Task { @MainActor in
            state.update(from: response)
        }
        return response
    }
    
    public func getOrCreate(watch: Bool = false) async throws -> GetOrCreateFeedResponse {
        let request = GetOrCreateFeedRequest(watch: watch) //TODO: add other stuff
        let response = try await apiClient.getOrCreateFeed(
            feedGroupId: group,
            feedId: id,
            getOrCreateFeedRequest: request
        )
        Task { @MainActor in
            state.update(from: response)
        }
        return response
    }
    
    public func addActivity(text: String) async throws -> AddActivityResponse {
        let response = try await apiClient.addActivity(
            addActivityRequest: .init(fids: [fid], text: text, type: "activity.added")
        )
        Task { @MainActor in
            state.activities.append(response.activity)
        }
        return response
    }
    
    func onEvent(_ event: any Event) {
        print("====== event: \(event)")
        if let event = event as? FeedsEvent {
            switch event {
            case .typeActivityAddedEvent(let activityAddedEvent):
                self.state.activities.append(activityAddedEvent.activity)
                break
            case .typeReactionAddedEvent(let reactionAddedEvent):
                break
            case .typeReactionRemovedEvent(let reactionRemovedEvent):
                break
            case .typeActivityRemovedEvent(let activityRemovedEvent):
                break
            case .typeActivityUpdatedEvent(let activityUpdatedEvent):
                break
            case .typeBookmarkAddedEvent(let bookmarkAddedEvent):
                break
            case .typeBookmarkRemovedEvent(let bookmarkRemovedEvent):
                break
            case .typeBookmarkUpdatedEvent(let bookmarkUpdatedEvent):
                break
            case .typeCommentAddedEvent(let commentAddedEvent):
                break
            case .typeCommentRemovedEvent(let commentRemovedEvent):
                break
            case .typeCommentUpdatedEvent(let commentUpdatedEvent):
                break
            case .typeFeedCreatedEvent(let feedCreatedEvent):
                break
            case .typeFeedRemovedEvent(let feedRemovedEvent):
                break
            case .typeFeedGroupChangedEvent(let feedGroupChangedEvent):
                break
            case .typeFeedGroupRemovedEvent(let feedGroupRemovedEvent):
                break
            case .typeFollowAddedEvent(let followAddedEvent):
                break
            case .typeFollowRemovedEvent(let followRemovedEvent):
                break
            case .typeFollowUpdatedEvent(let followUpdatedEvent):
                break
            case .typeConnectedEvent(let connectedEvent):
                break
            case .typeHealthCheckEvent(let healthCheckEvent):
                break
            case .typeConnectionErrorEvent(let connectionErrorEvent):
                break
            }
        }
    }
}
