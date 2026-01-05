//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct NotificationFeedView: View {
    let notificationFeed: Feed
    
    @ObservedObject var state: FeedState
    
    @StateObject var imageCache: ImagesCache
        
    init(notificationFeed: Feed, feedsClient: FeedsClient) {
        self.notificationFeed = notificationFeed
        state = notificationFeed.state
        _imageCache = StateObject(wrappedValue: ImagesCache(feedsClient: feedsClient))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Notifications")
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                
                HStack {
                    Spacer()
                    if state.notificationStatus?.unread ?? 0 > 0 {
                        Button {
                            Task {
                                try await notificationFeed.markActivity(
                                    request: .init(markAllRead: true)
                                )
                            }
                        } label: {
                            Text("Mark all as read")
                        }
                    }
                }
                
                ForEach(state.aggregatedActivities) { activity in
                    HStack {
                        UserAvatar(url: activity.activities.first?.user.imageURL)
                        Text(activity.displayText)
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
                    .background(
                        isActivityRead(id: activity.id) ? nil : Color.blue.opacity(0.05).cornerRadius(16)
                    )
                    .task {
                        if let first = activity.activities.first {
                            try? await imageCache.check(activityData: first)
                        }
                    }
                    .onTapGesture {
                        if !isActivityRead(id: activity.id) {
                            let ids = activity.activities.map(\.id)
                            let request = MarkActivityRequest(
                                markRead: ids
                            )
                            Task {
                                do {
                                    try await notificationFeed.markActivity(request: request)
                                } catch {
                                    log.error("Error marking the activities as read: \(error)")
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    func isActivityRead(id: String) -> Bool {
        state.notificationStatus?.readActivities.contains(id) == true
    }
}

@MainActor
class ImagesCache: ObservableObject {
    @Published var activityImages = [String: URL]()
    
    private let feedsClient: FeedsClient
    
    init(feedsClient: FeedsClient) {
        self.feedsClient = feedsClient
    }
    
    func check(activityData: ActivityData) async throws {
        if let activityId = activityData.notificationContext?.target?.id {
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

extension AggregatedActivityData {
    var displayText: String {
        guard !activities.isEmpty else {
            return ""
        }
        let firstUser = activities.first?.user.name ?? "Someone"
        let actionText = displayTextForAggregationType(activities.first?.type ?? "reaction")
        var text = "\(firstUser) \(actionText)"
        let otherUsers = userCount == 2 ? "other" : "others"
        if userCount > 1 {
            text = "\(firstUser) and \(userCount - 1) \(otherUsers) \(actionText)"
        }
        return text
    }
    
    func displayTextForAggregationType(_ type: String) -> String {
        if type == "comment" {
            "commented on your activity"
        } else if type == "reaction" {
            "reacted on your activity"
        } else if type == "follow" {
            "followed you"
        } else {
            ""
        }
    }
}
