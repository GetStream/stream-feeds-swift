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
    
    @discardableResult
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
    
    @discardableResult
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
    
    @discardableResult
    public func addComment(activityId: String, request: AddCommentRequest) async throws -> AddCommentResponse {
        try await apiClient.addComment(activityId: activityId, addCommentRequest: request)
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
                Task { @MainActor in
                    state.activities[index] = activity
                }
            }
        } else if let event = event as? CommentAddedEvent {
            let comment = event.comment
            if let index = state.activities.firstIndex(where: { $0.id == comment.activityId }) {
                let activity = state.activities[index]
                var comments = activity.comments ?? []
                if !comments.contains(comment) {
                    comments.append(comment)
                    activity.comments = comments
                    activity.commentCount += 1
                    Task { @MainActor in
                        state.activities[index] = activity
                    }
                }
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
