//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct FeedsListRowView: View {
    let activity: ActivityData
    let feed: Feed
    let client: FeedsClient
    
    let onDelete: (ActivityData) -> Void
    let onUpdate: (ActivityData, String) -> Void
    let onComment: (ActivityData) -> Void
    
    var body: some View {
        VStack {
            if let parent = activity.parent {
                Text("\(activity.user.name ?? activity.user.id) reposted")
                ActivityView(
                    user: parent.user,
                    ownCapabilities: feed.state.ownCapabilities,
                    text: parent.text ?? "",
                    attachments: parent.attachments,
                    activity: activity
                )
            } else if let poll = activity.poll {
                HStack(alignment: .top, spacing: 8) {
                    UserAvatar(url: activity.user.imageURL)
                    PollAttachmentView(
                        feedsClient: client,
                        feed: feed,
                        activityData: activity,
                        pollData: poll,
                        isFirst: true
                    )
                }
                .padding(.horizontal)
            } else {
                ActivityView(
                    user: activity.user,
                    ownCapabilities: feed.state.ownCapabilities,
                    text: activity.text ?? "",
                    attachments: activity.attachments,
                    activity: activity
                )
            }
            
            HStack(spacing: 32) {
                Spacer()
                
                HStack {
                    Button {
                        onComment(activity)
                    } label: {
                        Image(systemName: "message")
                    }
                    
                    Text("\(activity.commentCount)")
                        .monospacedDigit()
                }
                
                HStack {
                    Button {
                        Task {
                            do {
                                if activity.ownReactions.isEmpty {
                                    try await feed.addReaction(activityId: activity.id, request: .init(createNotificationActivity: true, type: "heart"))
                                } else {
                                    try await feed.deleteReaction(activityId: activity.id, type: "heart")
                                }
                            } catch {
                                log.error("Error adding a reaction \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: !activity.ownReactions.isEmpty ? "heart.fill" : "heart")
                    }
                    
                    Text("\(activity.reactionCount)")
                        .monospacedDigit()
                }
                
                HStack {
                    Button {
                        Task {
                            do {
                                try await feed.repost(activityId: activity.id, text: nil)
                            } catch {
                                log.error("Error reposting a post \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Text("\(activity.shareCount)")
                        .monospacedDigit()
                }
                
                HStack {
                    Button {
                        Task {
                            do {
                                if activity.ownBookmarks.isEmpty {
                                    try await feed.addBookmark(activityId: activity.id)
                                } else {
                                    try await feed.deleteBookmark(activityId: activity.id)
                                }
                            } catch {
                                log.error("Error adding a bookmark \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: !activity.ownBookmarks.isEmpty ? "bookmark.fill" : "bookmark")
                    }
                    
                    Text("\(activity.bookmarkCount)")
                        .monospacedDigit()
                }
                
                Spacer()
            }
            
            Divider()
        }
        .padding(.top, 4)
        .contentShape(.rect)
        .contextMenu {
            if activity.user.id == client.user.id {
                if activity.parent == nil && activity.poll == nil {
                    Button {
                        onUpdate(activity, activity.text ?? "")
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
                
                Button(role: .destructive) {
                    onDelete(activity)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}
