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
    
    var user: User
    
    private let apiClient: DefaultAPI
    
    public internal(set) var state = FeedState()
    
    internal init(group: String, id: String, user: User, apiClient: DefaultAPI) {
        self.apiClient = apiClient
        self.group = group
        self.id = id
        self.user = user
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
            addActivityRequest: .init(fids: [fid], text: text, type: "post")
        )
        add(activity: response.activity)
        return response
    }
    
    @discardableResult
    public func addReaction(activityId: String, request: AddReactionRequest) async throws -> AddReactionResponse {
        try await apiClient.addReaction(activityId: activityId, addReactionRequest: request)
    }
    
    @discardableResult
    public func removeReaction(activityId: String) async throws -> RemoveActivityReactionResponse {
        try await apiClient.removeActivityReaction(activityId: activityId)
    }
    
    func onEvent(_ event: any Event) {
        if let event = event as? ActivityAddedEvent {
            add(activity: event.activity)
        } else if let event = event as? ReactionAddedEvent {
            let reaction = event.reaction
            if let index = state.activities.firstIndex(where: { $0.id == reaction.activityId }) {
                let activity = state.activities[index]
                activity.latestReactions?.append(reaction)
                var groups = activity.reactionGroups ?? [String: ReactionGroup]()
                let existing = groups[reaction.type] ?? ReactionGroup(count: 0, firstReactionAt: .distantPast, lastReactionAt: .distantPast)
                let group = ReactionGroup(
                    count: existing.count + 1,
                    firstReactionAt: existing.firstReactionAt,
                    lastReactionAt: event.createdAt
                )
                groups[reaction.type] = group
                if reaction.user.id == user.id {
                    var ownReactions = activity.ownReactions ?? []
                    ownReactions.append(reaction)
                    activity.ownReactions = ownReactions
                }
                activity.reactionGroups = groups
                state.activities[index] = activity
            }
        }
    }
    
    private func add(activity: Activity) {
        if !self.state.activities.map(\.id).contains(activity.id) {
            Task { @MainActor in
                //TODO: consider sorting
                self.state.activities.insert(activity, at: 0)
            }
        }
    }
}
