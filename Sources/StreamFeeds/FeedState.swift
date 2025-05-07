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
    
    @MainActor
    func update(from response: CreateFeedResponse) {
        //TODO: implement
    }
    
    @MainActor
    func update(from response: GetFeedResponse) {
        self.activities = response.activities
    }
}

extension Activity: Identifiable {}
