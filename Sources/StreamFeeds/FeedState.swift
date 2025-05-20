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
    
    @MainActor
    func update(from response: GetOrCreateFeedResponse) {
        self.activities = response.activities
        self.followers = response.followers
        self.following = response.following
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
}

extension Activity: Identifiable {}
