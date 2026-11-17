//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import StreamFeeds

@MainActor struct Snippets_05_03_NotificationFeeds {
    var client: FeedsClient!
    var ericFeed: Feed!
    var janeFeed: Feed!
    var notificationFeed: Feed!
    var janeActivity: ActivityData!
    var saraComment: CommentData!
    var activityId: String!
    var activityId1: String!
    var activityId2: String!
    var commentId: String!

    func creatingNotificationActivities() async throws {
        // Eric follows Jane
        try await ericFeed.follow(
            janeFeed.feed,
            createNotificationActivity: true // When true Jane's notification feed will be updated with follow activity
        )

        // Eric comments on Jane's activity
        try await ericFeed.addComment(
            request: AddCommentRequest(
                comment: "Agree!",
                createNotificationActivity: true, // When true Jane's notification feed will be updated with comment activity
                objectId: janeActivity.id,
                objectType: "activity"
            )
        )

        // Eric reacts to Jane's activity
        try await ericFeed.addReaction(
            activityId: janeActivity.id,
            request: AddReactionRequest(
                createNotificationActivity: true, // When true Jane's notification feed will be updated with reaction activity
                type: "like"
            )
        )

        // Eric reacts to a comment posted to Jane's activity by Sara
        try await ericFeed.addCommentReaction(
            commentId: saraComment.id,
            request: AddCommentReactionRequest(
                createNotificationActivity: true, // When true Sara's notification feed will be updated with comment reaction activity
                type: "like"
            )
        )
    }

    func updatingMentions() async throws {
        // Alice updates her activity to mention Bob
        try await ericFeed.updateActivity(
            id: activityId,
            request: UpdateActivityRequest(
                handleMentionNotifications: true, // When true, Bob will receive a mention notification
                mentionedUserIds: ["bob"],
                text: "Hey @Bob check this out!"
            )
        )

        // Alice updates her comment to mention Charlie
        try await ericFeed.updateComment(
            commentId: commentId,
            request: UpdateCommentRequest(
                comment: "Hey @Charlie!",
                handleMentionNotifications: true, // When true, Charlie will receive a comment_mention notification
                mentionedUserIds: ["charlie"]
            )
        )

        // Alice removes mentions from her activity
        try await ericFeed.updateActivity(
            id: activityId,
            request: UpdateActivityRequest(
                handleMentionNotifications: true, // When true, mention notifications for removed users are deleted
                mentionedUserIds: [],
                text: "Updated text without mentions"
            )
        )
    }

    func deletingNotificationActivities() async throws {
        // Eric unfollows Jane
        try await ericFeed.unfollow(
            janeFeed.feed,
            // When true the corresponding notification activity will be removed from Jane's notification feed
            deleteNotificationActivity: true
        )

        // Eric removes his comment
        try await ericFeed.deleteComment(
            commentId: commentId,
            // When true the corresponding notification activity will be removed from Jane's notification feed
            deleteNotificationActivity: true
        )

        // Eric removes his activity reaction
        try await ericFeed.deleteReaction(
            activityId: janeActivity.id,
            type: "like",
            // When true the corresponding notification activity will be removed from Jane's notification feed
            deleteNotificationActivity: true
        )

        // Eric removes his comment reaction
        try await ericFeed.deleteCommentReaction(
            commentId: saraComment.id,
            type: "like",
            // When true the corresponding notification activity will be removed from Jane's notification feed
            deleteNotificationActivity: true
        )

        // Eric deletes his activity with mentions
        try await ericFeed.deleteActivity(
            id: activityId,
            // When true, mention notifications for all mentioned users will be removed
            deleteNotificationActivity: true
        )

        // Eric deletes multiple activities with mentions (batch operation)
        try await client.deleteActivities(
            request: DeleteActivitiesRequest(
                // When true, mention notifications for all mentioned users will be removed
                deleteNotificationActivity: true,
                ids: [activityId1, activityId2]
            )
        )
    }

    func serverSideIsSeenIsRead() async throws {
        try await notificationFeed.getOrCreate()
        let group = notificationFeed.state.aggregatedActivities[0]
        let isRead = group.isRead == true
        let isSeen = group.isSeen == true

        suppressUnusedWarning(isRead, isSeen)
    }

    func unreadUnseenCounts() async throws {
        try await notificationFeed.getOrCreate()

        // The aggregate counts, for a badge
        let status = notificationFeed.state.notificationStatus
        print("\(status?.unread ?? 0) unread, \(status?.unseen ?? 0) unseen")

        // And they stay current as events arrive
        let cancellable = notificationFeed.state.$notificationStatus.sink { status in
            print("unread: \(status?.unread ?? 0)")
        }

        suppressUnusedWarning(cancellable)
    }

    func markingNotificationsAsSeen() async throws {
        try await notificationFeed.markActivity(
            request: MarkActivityRequest(
                // Mark all notifications as seen...
                markAllSeen: true,
                // ...or only selected ones
                markSeen: [ /* group names to mark as seen */ ]
            )
        )
    }

    func markingNotificationsAsRead() async throws {
        try await notificationFeed.markActivity(
            request: MarkActivityRequest(
                // Mark all notifications as read...
                markAllRead: true,
                // ...or only selected ones
                markRead: [ /* group names to mark as read */ ]
            )
        )
    }

    func readingFlatNotifications() async throws {
        let notificationFeed = client.feed(group: "notification", id: "john")
        try await notificationFeed.getOrCreate()

        // With aggregation off, use `activities` (not `aggregatedActivities`)
        let page1 = notificationFeed.state.activities

        // Load more
        try await notificationFeed.queryMoreActivities()
        let page1And2 = notificationFeed.state.activities

        suppressUnusedWarning(page1, page1And2)
    }

    func perActivityIsSeenIsRead() {
        let activity = notificationFeed.state.activities.first
        let isRead = activity?.isRead == true
        let isSeen = activity?.isSeen == true

        suppressUnusedWarning(isRead, isSeen)
    }

    func markingFlatNotifications(activity: ActivityData) async throws {
        try await notificationFeed.markActivity(
            request: MarkActivityRequest(
                markSeen: [activity.id]
                // or markRead: [activity.id]
            )
        )
    }
}
