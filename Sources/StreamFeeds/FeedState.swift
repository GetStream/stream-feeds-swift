//
//  FeedState.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 7.5.25.
//

import Combine
import Foundation

public class FeedState: ObservableObject {
    
    @Published public var activities = [Activity]()
    @Published public var followers = [Follow]()
    @Published public var following = [Follow]()
    @Published public var followRequests = [Follow]()
    
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
    func addFollowInfo(from follow: Follow) {
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

extension Activity: Identifiable {}
