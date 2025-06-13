//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

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
                    text: parent.text ?? "",
                    attachments: parent.attachments,
                    activity: activity,
                    onUpdate: onUpdate,
                    onDelete: onDelete
                )
            } else if activity.poll != nil {
                PollAttachmentView(
                    feedsClient: client,
                    feed: feed,
                    activity: activity,
                    isFirst: true
                )
            } else {
                ActivityView(
                    user: activity.user,
                    text: activity.text ?? "",
                    attachments: activity.attachments,
                    activity: activity,
                    onUpdate: onUpdate,
                    onDelete: onDelete
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
                }
                
                HStack {
                    Button {
                        Task {
                            do {
                                if activity.ownReactions.isEmpty {
                                    try await feed.addReaction(activityId: activity.id, request: .init(type: "heart"))
                                } else {
                                    try await feed.deleteReaction(activityId: activity.id, type: "heart")
                                }
                            } catch {
                                print("===== \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: !activity.ownReactions.isEmpty ? "heart.fill" : "heart")
                    }
                    
                    Text("\(activity.reactionCount)")
                }
                
                HStack {
                    Button {
                        Task {
                            do {
                                try await feed.repost(activityId: activity.id, text: nil)
                            } catch {
                                print("===== \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Text("\(activity.shareCount)")
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
                                print("===== \(error)")
                            }
                        }
                    } label: {
                        Image(systemName: !activity.ownBookmarks.isEmpty ? "bookmark.fill" : "bookmark")
                    }
                    
                    Text("\(activity.bookmarkCount)")
                }
                
                Spacer()
            }
            
            Divider()
        }
    }
}
