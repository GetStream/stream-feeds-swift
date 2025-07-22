//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct NotificationFeedView: View {
    let notificationFeed: Feed
    
    @ObservedObject var state: FeedState
    
    init(notificationFeed: Feed) {
        self.notificationFeed = notificationFeed
        state = notificationFeed.state
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Notifications")
                    .font(.title)
                ForEach(state.activities) { activity in
                    HStack {
                        UserAvatar(url: activity.user.imageURL)
                        Text(activity.text ?? "")
                        Spacer()
                    }
                    .padding(.all, 8)
                }
            }
            .padding()
        }
    }
}
