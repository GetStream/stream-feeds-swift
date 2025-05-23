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
    
    @MainActor
    func update(from response: GetOrCreateFeedResponse) {
        self.activities = response.activities
        self.followers = response.followers.filter { $0.request == false || $0.requestAcceptedAt != nil }
        self.following = response.following
        self.followRequests = response.followers.filter {
            $0.request == true && ($0.requestAcceptedAt == nil && $0.requestRejectedAt == nil)
        }
    }
    
    @MainActor
    func addFollowInfo(from follow: FollowResponse) {
        if !following.contains(follow) {
            following.append(follow)
        }
    }
    
    @MainActor
    func removeFollowInfo(fid: String) {
        following.removeAll(where: { $0.targetFid == fid })
    }
    
    @MainActor
    func removeFollowRequest(sourceFid: String, targetFid: String) {
        followRequests.removeAll(where: { $0.sourceFid == sourceFid && $0.targetFid == targetFid })
    }
}

extension ActivityResponse: Identifiable {}
