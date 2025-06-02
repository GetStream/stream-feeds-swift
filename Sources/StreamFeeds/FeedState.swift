//
//  FeedState.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 7.5.25.
//

import Combine
import Foundation

public class FeedState: ObservableObject {
    
    @Published public var activities = [ActivityResponse]()
    @Published public var followers = [FollowResponse]()
    @Published public var following = [FollowResponse]()
    @Published public var followRequests = [FollowResponse]()
    @Published public var members = [FeedMemberResponse]()

    @MainActor
    func update(from response: GetOrCreateFeedResponse) {
        self.activities = response.activities
        self.followers = response.followers.filter { $0.status == .accepted || $0.requestAcceptedAt != nil }
        self.following = response.following
        self.followRequests = response.followers.filter {
            $0.status == .pending
        }
        self.members = response.members
    }
    
    @MainActor
    func addFollowInfo(from follow: FollowResponse) {
        if !following.contains(follow) {
            following.append(follow)
        }
    }
    
    @MainActor
    func removeFollowInfo(fid: String) {
        following.removeAll(where: { $0.targetFeed.fid == fid })
    }
    
    @MainActor
    func removeFollowRequest(sourceFid: String, targetFid: String) {
        followRequests.removeAll(where: { $0.sourceFeed.fid == sourceFid && $0.targetFeed.fid == targetFid })
    }
}

extension ActivityResponse: Identifiable {}
