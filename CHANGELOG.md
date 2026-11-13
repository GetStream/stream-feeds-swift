# StreamFeeds iOS SDK CHANGELOG

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

# Upcoming

### ✅ Added
- Add `enrichOwnFields` to `ActivitiesQuery` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `language` to `ActivitiesQuery` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `id`, `skipEnrichUrl` and `skipPush` to `ActivityAddCommentRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `language` to `ActivityCommentsQuery` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `collections` to `ActivityData` [#99](https://github.com/GetStream/stream-feeds-swift/pull/99)
- Add `friendReactionCount`, `friendReactions`, `position`, `reasons`, `scoreVariables` and `selectorSource` to `ActivityData` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `isRead`, `isSeen`, `isWatched`, `latestShares`, `metrics`, `moderationAction`, `preview`, `restrictReplies` and `topLevelCommentCount` to `ActivityData` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `originalLanguage`, `translations` and `translatedText(for:)` to `ActivityData` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `createNotificationActivity`, `restrictReplies`, `skipEnrichUrl` and `skipPush` to `ActivityRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `enrichOwnFields` to `AddActivityRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `targetFeeds` to `AddCommentReactionRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `id` and `skipEnrichUrl` to `AddCommentRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `targetFeeds` to `AddReactionRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `isRead`, `isSeen` and `isWatched` to `AggregatedActivityData` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `id` to `AppData` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `comment`, `objectId` and `objectType` to `BookmarkData` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `user` to `BookmarkFolderData` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `enrichOwnFields` to `BookmarksQuery` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `language` to `BookmarksQuery` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `reference` to `CollectionData` [#107](https://github.com/GetStream/stream-feeds-swift/pull/107)
- Add `CollectionsQuery` and `CollectionList` for querying collections with `FeedsClient.collectionList(for:)` [#107](https://github.com/GetStream/stream-feeds-swift/pull/107)
- Add `bookmarkCount`, `editedAt` and `hidden` to `CommentData` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `originalLanguage`, `translations` and `translatedText(for:)` to `CommentData` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `language` to `CommentRepliesQuery` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `hidden` to `CommentsFilterField` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `language` to `CommentsQuery` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `EnrichmentOptions` for skipping or adding enrichments with `FeedQuery.enrichmentOptions` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `collectionReferences` and `collections` to `FeedAddActivityRequest` [#99](https://github.com/GetStream/stream-feeds-swift/pull/99)
- Add `createNotificationActivity`, `enrichOwnFields`, `restrictReplies`, `skipEnrichUrl` and `skipPush` to `FeedAddActivityRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `ownFollowings` to `FeedData` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `activityCount` and `location` to `FeedData` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `location` to `FeedInput` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `enrichmentOptions`, `friendReactionsOptions`, `overwriteInterestWeights` and `viewerLocation` to `FeedQuery` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `language` to `FeedQuery` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `activityIdAround` to `FeedQuery` [#105](https://github.com/GetStream/stream-feeds-swift/pull/105)
- Add `canLoadPreviousActivities` to `FeedState` [#105](https://github.com/GetStream/stream-feeds-swift/pull/105)
- Add activities restored on another client to `FeedState.activities` [#108](https://github.com/GetStream/stream-feeds-swift/pull/108)
- Add `FeedSuggestionData` with the reason and scores for each follow suggestion [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `enrichOwnFields` to `FeedsQuery` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `FriendReactionType` for choosing between followed and mutual users in `FriendReactionsOptions.type` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `FriendReactionsOptions` for loading friend reactions with `FeedQuery.friendReactionsOptions` [#102](https://github.com/GetStream/stream-feeds-swift/pull/102)
- Add `idAround` to `GetOrCreateFeedRequest` [#105](https://github.com/GetStream/stream-feeds-swift/pull/105)
- Add `blocklistsMatched` to `ModerationV2Response` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `comment`, `custom` and `parentActivity` to `NotificationTarget` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `comment` and `custom` to `NotificationTrigger` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `mutes` and `pushPreferences` to `OwnUser` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `ShareData` for `ActivityData.latestShares` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `bookmarkCount`, `editedAt` and `hidden` to `ThreadedCommentData` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `originalLanguage`, `translations` and `translatedText(for:)` to `ThreadedCommentData` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `enrichOwnFields`, `handleMentionNotifications`, `mentionedUserIds`, `restrictReplies`, `runActivityProcessors`, `searchData`, `skipEnrichUrl` and `visibilityTag` to `UpdateActivityRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `attachments`, `handleMentionNotifications`, `mentionedUserIds` and `skipEnrichUrl` to `UpdateCommentRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `clearLocation`, `description`, `enrichOwnFields`, `filterTags`, `location` and `name` to `UpdateFeedRequest` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `createdBy` to `UserReactivatedEvent` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)
- Add `Activity.translate(to:)` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `Activity.translateComment(commentId:to:)` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `activityCopyLimit`, `enrichOwnFields` and `skipPush` to `Feed.follow(...)` [#101](https://github.com/GetStream/stream-feeds-swift/pull/101)
- Add `Feed.queryActivities(around:limit:)` [#105](https://github.com/GetStream/stream-feeds-swift/pull/105)
- Add `Feed.queryPreviousActivities(limit:)` [#105](https://github.com/GetStream/stream-feeds-swift/pull/105)
- Add `Feed.restoreActivity(id:)` [#108](https://github.com/GetStream/stream-feeds-swift/pull/108)
- Add `Feed.translateActivity(id:to:)` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `Feed.translateComment(commentId:to:)` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `Feed.updateActivityPartial(id:request:)` [#108](https://github.com/GetStream/stream-feeds-swift/pull/108)
- Add `language` to `FeedsClient.activity(for:in:data:)` [#104](https://github.com/GetStream/stream-feeds-swift/pull/104)
- Add `FeedsClient.createCollections(request:)`, `FeedsClient.updateCollections(request:)` and `FeedsClient.deleteCollections(references:)` [#107](https://github.com/GetStream/stream-feeds-swift/pull/107)
- Add `FeedsClient.readCollections(references:)` [#99](https://github.com/GetStream/stream-feeds-swift/pull/99)

### 🐞 Fixed
- Fix comment bookmarks sharing the same `BookmarkData.id` [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)

### 🔄 Changed
- `Feed.queryFollowSuggestions(limit:)` returns `FeedSuggestionData`. The overload returning `[FeedData]` is deprecated [#103](https://github.com/GetStream/stream-feeds-swift/pull/103)

### 🚨 Breaking Changes
- `OwnUser` moves its user fields under `user`, for example `ownUser.id` -> `ownUser.user.id` [#98](https://github.com/GetStream/stream-feeds-swift/pull/98)

# [0.6.0](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.6.0)
_November 04, 2026_

### ✅ Added
- Add `deleteNotificationActivity` to `Feed.unfollow(_:)`, `DeleteActivitiesRequest` and the `Feed` and `Activity` methods that delete activities, comments and reactions [#86](https://github.com/GetStream/stream-feeds-swift/pull/86)
- Add `keepHistory` to `Feed.unfollow(_:)` [#86](https://github.com/GetStream/stream-feeds-swift/pull/86)
- Add `purgeUserActivities` to `Feed.deleteFeed(hardDelete:)` [#86](https://github.com/GetStream/stream-feeds-swift/pull/86)
- Add `StreamFeedsLogsUI`, an in-app log viewer for demo apps and debug builds [#80](https://github.com/GetStream/stream-feeds-swift/pull/80)
- Update generated models to the latest OpenAPI spec, which adds 17 new types [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Add `Feed.queryFollowRequests()` and `Feed.queryMoreFollowRequests(limit:)` for loading pending follow requests into `FeedState.followRequests` [#88](https://github.com/GetStream/stream-feeds-swift/pull/88)
- Add `FeedsConfig.isAutomaticSyncOnReconnectEnabled` for refetching loaded data in `Feed`, `Activity` and paginated lists after the web-socket reconnects (on by default) [#89](https://github.com/GetStream/stream-feeds-swift/pull/89)

### 🐞 Fixed
- Fix pending follows sent by a feed showing up in its own `FeedState.followRequests` [#88](https://github.com/GetStream/stream-feeds-swift/pull/88)

### ⚡ Performance
- Reduce SDK size by 3 MB [#83](https://github.com/GetStream/stream-feeds-swift/pull/83), [#84](https://github.com/GetStream/stream-feeds-swift/pull/84), [#90](https://github.com/GetStream/stream-feeds-swift/pull/90), [#91](https://github.com/GetStream/stream-feeds-swift/pull/91)

### 🔄 Changed
- Deprecate the `role` argument of `Feed.acceptFollow(_:role:)`, which the API no longer accepts [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Deprecate the `userId` argument of `Activity.getPoll(userId:)`, `deletePoll(userId:)`, `getPollOption(optionId:userId:)`, `deletePollOption(optionId:userId:)` and `deletePollVote(voteId:userId:)`, which the API no longer accepts [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Deprecate `PollVotesQuery.userId` and `FeedQuery.activitySelectorOptions`, which the API no longer accepts [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Deprecate `UserData.revokeTokensIssuedBefore` and `ReactionGroupData.sumScores`, which the API no longer returns [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Rename some generated models, for example `ReactionGroupResponse` -> `FeedsReactionGroupResponse`. The old names are deprecated [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- `FeedQuery`'s `followerLimit` and `followingLimit` now default to 10 [#88](https://github.com/GetStream/stream-feeds-swift/pull/88)

### 🚨 Breaking Changes
- Remove `OwnUser.revokeTokensIssuedBefore` and `OwnUser.pushNotifications`, which the API never returns for client-side connections [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Remove chat, video and server-side-only properties from generated models [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Replace nested enums in generated models with shared ones, for example `CommentResponse.CommentResponseStatus` -> `CommentStatus`, and change feed events' `feedVisibility` to `FeedVisibility?` [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Make generated models immutable and use `Double` instead of `Float` [#84](https://github.com/GetStream/stream-feeds-swift/pull/84)
- Replace enums in generated models with `RawRepresentable` types, and use them instead of `String` in `FeedData.visibility`, `CommentData.status`, `ThreadedCommentData.status`, `FollowData.pushPreference` and `PollData.votingVisibility` [#84](https://github.com/GetStream/stream-feeds-swift/pull/84)
- Nest the embedded model in `EntityCreatorResponse`, `FeedSuggestionResponse`, `ThreadedCommentResponse` and `UserResponsePrivacyFields`, for example `ThreadedCommentResponse.id` -> `ThreadedCommentResponse.comment.id` [#90](https://github.com/GetStream/stream-feeds-swift/pull/90)

# [0.5.3](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.5.3)
_June 11, 2026_

### 🔄 Changed
- Update StreamCore to 0.7.0, which fixes `Sendable` errors when building with Xcode 27 [#68](https://github.com/GetStream/stream-feeds-swift/pull/68)

# [0.5.2](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.5.2)
_February 09, 2026_

### 🔄 Changed
- Updated add activity request and response [#60](https://github.com/GetStream/stream-feeds-swift/pull/60)

# [0.5.1](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.5.1)
_December 08, 2025_

### 🐞 Fixed
- Fix `Package.swift` non-existent module [#56](https://github.com/GetStream/stream-feeds-swift/pull/56) 

# [0.5.0](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.5.0)
_November 19, 2025_

### ✅ Added
- Update local state when using activity batch operations in `FeedsClient` [#52](https://github.com/GetStream/stream-feeds-swift/pull/52)
- Keep `FeedData.ownCapabilities` up to date in every model when handling web-socket events [#51](https://github.com/GetStream/stream-feeds-swift/pull/51)
- Add filtering and sorting keys: [#53](https://github.com/GetStream/stream-feeds-swift/pull/53)
    - `ActivitiesFilterField.feeds`
    - `ActivitiesFilterField.interestTags`
    - `ActivitiesFilterField.near`
    - `ActivitiesFilterField.withinBounds`
    - `ModerationConfigsSortField.team`
### 🐞 Fixed
- Fix remote key for `ModerationConfigsSortField.key` [#53](https://github.com/GetStream/stream-feeds-swift/pull/53)
### 🔄 Changed
- Rename `ActivitiesFilterField.type` to `ActivitiesFilterField.activityType` [#53](https://github.com/GetStream/stream-feeds-swift/pull/53)

# [0.4.0](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.4.0)
_September 25, 2025_

### ✅ Added
- Comprehensive handling of web-socket events in the state-layer
- Add `ownCapabilities` to `FeedData`

# [0.3.0](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.3.0)
_September 19, 2025_

### ✅ Added
- Support for stories
- Web-socket reconnection for feeds
- Support for local filtering of data

# [0.2.0](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.2.0)
_August 19, 2025_

### ✅ Added
- Support for notification feeds
- Activity marking as seen and read
- Mentioning users
- Moderation updates

# [0.1.0](https://github.com/GetStream/stream-feeds-swift/releases/tag/0.1.0)
_July 18, 2025_

### ✅ Added

First alpha version of the iOS Feeds SDK, with the following features:
- Create different types of feeds and feed groups
- Personalization of feeds
- Post activities with attachments (images, video, polls, etc)
- Comments and threaded comments
- Reactions, bookmarks, reposts
- Follows and requests to follow
- and much more.

For more details on the supported features, please check our [docs](https://getstream.io/activity-feeds/docs/ios/).
