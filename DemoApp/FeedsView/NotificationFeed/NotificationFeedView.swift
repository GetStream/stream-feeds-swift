//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct NotificationFeedView: View {
    let notificationFeed: Feed
    
    @ObservedObject var state: FeedState
    
    @StateObject var imageCache: ImageCache
        
    init(notificationFeed: Feed, feedsClient: FeedsClient) {
        self.notificationFeed = notificationFeed
        state = notificationFeed.state
        _imageCache = StateObject(wrappedValue: ImageCache(feedsClient: feedsClient))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Notifications")
                    .font(.title)
                    .bold()
                ForEach(state.activities) { activity in
                    HStack {
                        UserAvatar(url: activity.user.imageURL)
                        Text(activity.text ?? "")
                        Spacer()
                        if let url = imageCache.activityImages[activity.id] {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color(UIColor.secondarySystemBackground)
                            }
                            .frame(width: 36, height: 36)
                            .cornerRadius(8)
                        } else {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 36, height: 36)
                        }
                    }
                    .padding(.all, 8)
                    .task {
                        try? await imageCache.check(activityData: activity)
                    }
                }
            }
            .padding()
        }
    }
}

@MainActor
class ImageCache: ObservableObject {
    @Published var activityImages = [String: URL]()
    
    private let feedsClient: FeedsClient
    
    init(feedsClient: FeedsClient) {
        self.feedsClient = feedsClient
    }
    
    func check(activityData: ActivityData) async throws {
        if let activityId = activityData.object?["activity_id"]?.stringValue {
            let feedId = FeedId(group: "user", id: feedsClient.user.id)
            let activity = feedsClient.activity(for: activityId, in: feedId)
            try await activity.get()
            if let attachment = activity.state.activity?.attachments.first,
               let imageUrl = attachment.imageUrl {
                activityImages[activityData.id] = URL(string: imageUrl)
            }
        }
    }
}
