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
    func update(from response: GetOrCreateFeedResponse) {
        self.activities = response.activities
    }
}

extension Activity: Identifiable {}
