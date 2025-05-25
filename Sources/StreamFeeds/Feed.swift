//
//  FlatFeed.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 7.5.25.
//

import Foundation
import StreamCore

public class Feed: WSEventsSubscriber {
    
    public let group: String
    public let id: String
    
    public var fid: String {
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
    public func getOrCreate(request: GetOrCreateFeedRequest) async throws -> GetOrCreateFeedResponse {
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
    public func addActivity(fids: [String], text: String, attachments: [Attachment] = []) async throws -> AddActivityResponse {
        let response = try await apiClient.addActivity(
            addActivityRequest: .init(attachments: attachments, fids: fids, text: text, type: "post")
        )
        add(activity: response.activity)
        return response
    }
    
    @discardableResult
    public func updateActivity(id: String, request: UpdateActivityRequest) async throws -> UpdateActivityResponse {
        let response = try await apiClient.updateActivity(activityId: id, updateActivityRequest: request)
        add(activity: response.activity)
        return response
    }
    
    @discardableResult
    public func deleteActivity(id: String, hardDelete: Bool? = nil) async throws -> DeleteActivityResponse {
        let response = try await apiClient.deleteActivity(activityId: id, hardDelete: hardDelete)
        removeActivity(id: id)
        return response
    }
    
    @discardableResult
    public func repost(activityId: String, text: String?) async throws -> AddActivityResponse {
        let response = try await apiClient.addActivity(
            addActivityRequest: .init(fids: [fid], parentId: activityId, text: text, type: "post")
        )
        add(activity: response.activity)
        return response
    }
    
    @discardableResult
    public func addReaction(activityId: String, request: AddReactionRequest) async throws -> AddReactionResponse {
        try await apiClient.addReaction(activityId: activityId, addReactionRequest: request)
    }
    
    @discardableResult
    public func removeReaction(activityId: String) async throws -> DeleteActivityReactionResponse {
        try await apiClient.deleteActivityReaction(activityId: activityId)
    }
    
    @discardableResult
    public func addComment(request: AddCommentRequest) async throws -> AddCommentResponse {
        try await apiClient.addComment(addCommentRequest: request)
    }
    
    @discardableResult
    public func addBookmark(activityId: String) async throws -> AddBookmarkResponse {
        try await apiClient.addBookmark(activityId: activityId, addBookmarkRequest: .init()) //TODO: folder stuff
    }
    
    @discardableResult
    public func removeBookmark(activityId: String) async throws -> DeleteBookmarkResponse {
        try await apiClient.deleteBookmark(activityId: activityId)
    }
    
    // MARK: - Follows
    
    @discardableResult
    public func follow(request: SingleFollowRequest) async throws -> SingleFollowResponse {
        let response = try await apiClient.follow(singleFollowRequest: request)
        await state.addFollowInfo(from: response.follow)
        return response
    }
    
    @discardableResult
    public func unfollow(sourceFid: String? = nil, targetFid: String) async throws -> UnfollowResponse {
        let response = try await apiClient.unfollow(source: sourceFid ?? self.fid, target: targetFid)
        await state.removeFollowInfo(fid: targetFid)
        return response
    }
    
    @discardableResult
    public func acceptFollow(request: AcceptFollowRequest) async throws -> AcceptFollowResponse {
        let response = try await apiClient.acceptFollow(acceptFollowRequest: request)
        await state.removeFollowRequest(sourceFid: request.sourceFid, targetFid: request.targetFid)
        return response
    }
    
    @discardableResult
    public func rejectFollow(request: RejectFollowRequest) async throws -> RejectFollowResponse {
        let response = try await apiClient.rejectFollow(rejectFollowRequest: request)
        await state.removeFollowRequest(sourceFid: request.sourceFid, targetFid: request.targetFid)
        return response
    }
    
    func onEvent(_ event: any Event) {
        if let event = event as? ActivityAddedEvent {
            add(activity: event.activity)
        } else if let event = event as? ActivityReactionAddedEvent {
            let reaction = event.reaction
            if let index = state.activities.firstIndex(where: { $0.id == reaction.activityId }) {
                let activity = state.activities[index]
                activity.latestReactions.append(reaction)
                var groups = activity.reactionGroups
                let existing = groups[reaction.type] ?? ReactionGroupResponse(count: 0, firstReactionAt: .distantPast, lastReactionAt: .distantPast)
                let group = ReactionGroupResponse(
                    count: existing.count + 1,
                    firstReactionAt: existing.firstReactionAt,
                    lastReactionAt: event.createdAt
                )
                groups[reaction.type] = group
                if reaction.user.id == user.id {
                    var ownReactions = activity.ownReactions
                    ownReactions.append(reaction)
                    activity.ownReactions = ownReactions
                }
                activity.reactionGroups = groups
                Task { @MainActor in
                    state.activities[index] = activity
                }
            }
        } else if let event = event as? ActivityUpdatedEvent {
            if let index = state.activities.firstIndex(where: { $0.id == event.activity.id }) {
                Task { @MainActor in
                    state.activities[index] = event.activity
                }
            }
        } else if let event = event as? CommentAddedEvent {
            let comment = event.comment
            if let index = state.activities.firstIndex(where: { $0.id == comment.objectId }) {
                let activity = state.activities[index]
                var comments = activity.comments
                if !comments.contains(comment) {
                    comments.append(comment)
                    activity.comments = comments
                    activity.commentCount += 1
                    Task { @MainActor in
                        state.activities[index] = activity
                    }
                }
            }
        } else if let event = event as? BookmarkAddedEvent {
            if let index = state.activities.firstIndex(where: { $0.id == event.activityId }), let user = event.user {
                let activity = state.activities[index]
                var ownBookmarks = activity.ownBookmarks
                let bookmark = BookmarkResponse(
                    activityId: event.activityId,
                    createdAt: event.createdAt,
                    custom: event.custom,
                    folder: .init(createdAt: Date(), id: "bookmarks", name: "Bookmarks", updatedAt: Date()),
                    updatedAt: event.createdAt,
                    user: user.toUserResponse()
                )
                ownBookmarks.append(bookmark)
                activity.ownBookmarks = ownBookmarks
                activity.bookmarkCount += 1
                Task { @MainActor in
                    state.activities[index] = activity
                }
            }
        } else if let event = event as? BookmarkDeletedEvent {
            if let index = state.activities.firstIndex(where: { $0.id == event.bookmark.activityId }) {
                let activity = state.activities[index]
                var ownBookmarks = activity.ownBookmarks
                ownBookmarks.removeAll()
                activity.ownBookmarks = ownBookmarks
                activity.bookmarkCount = max(0, activity.bookmarkCount - 1)
                Task { @MainActor in
                    state.activities[index] = activity
                }
            }
        } else if let event = event as? ActivityDeletedEvent {
            removeActivity(id: event.activity.id)
        } else if let event = event as? FollowAddedEvent, event.fid == fid {
            if !event.follow.request {
                Task { @MainActor in
                    if event.follow.sourceFid == fid {
                        if !self.state.following.contains(event.follow) {
                            self.state.following.append(event.follow)
                        }
                    } else {
                        if !self.state.followers.contains(event.follow) {
                            self.state.followers.append(event.follow)
                        }
                    }
                }
            } else {
                Task { @MainActor in
                    if event.follow.sourceFid != fid {
                        if !self.state.followRequests.contains(event.follow) {
                            self.state.followRequests.append(event.follow)
                        }
                    }
                }

            }
        } else if let event = event as? FollowRemovedEvent, event.fid == fid {
            Task { @MainActor in
                if event.follow.sourceFid == fid {
                    self.state.following.removeAll(where: { $0.sourceFid == event.follow.sourceFid })
                } else {
                    self.state.followers.removeAll(where: { $0.targetFid == event.follow.targetFid })
                }
            }
        } else if let event = event as? FollowUpdatedEvent, event.fid == fid {
            if event.follow.targetFid == fid, event.follow.requestAcceptedAt != nil {
                if !self.state.followers.contains(event.follow) {
                    self.state.followers.append(event.follow)
                }
            }
        }
    }
    
    private func add(activity: ActivityResponse) {
        if !self.state.activities.map(\.id).contains(activity.id) {
            Task { @MainActor in
                //TODO: consider sorting
                self.state.activities.insert(activity, at: 0)
            }
        }
    }
    
    private func removeActivity(id: String) {
        Task { @MainActor in
            self.state.activities.removeAll(where: { $0.id == id })
        }
    }
}
