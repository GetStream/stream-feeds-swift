# StreamFeeds iOS SDK CHANGELOG

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

# Upcoming

### ✅ Added
- Add `deleteNotificationActivity` to `Feed.unfollow(_:)`, `DeleteActivitiesRequest` and the `Feed` and `Activity` methods that delete activities, comments and reactions [#86](https://github.com/GetStream/stream-feeds-swift/pull/86)
- Add `keepHistory` to `Feed.unfollow(_:)` [#86](https://github.com/GetStream/stream-feeds-swift/pull/86)
- Add `purgeUserActivities` to `Feed.deleteFeed(hardDelete:)` [#86](https://github.com/GetStream/stream-feeds-swift/pull/86)
- Add `StreamFeedsLogsUI`, an in-app log viewer for demo apps and debug builds [#80](https://github.com/GetStream/stream-feeds-swift/pull/80)
- Update generated models to the latest OpenAPI spec, which adds 17 new types [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)

### 🔄 Changed
- Deprecate the `role` argument of `Feed.acceptFollow(_:role:)`, which the API no longer accepts [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Deprecate the `userId` argument of `Activity.getPoll(userId:)`, `deletePoll(userId:)`, `getPollOption(optionId:userId:)`, `deletePollOption(optionId:userId:)` and `deletePollVote(voteId:userId:)`, which the API no longer accepts [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Deprecate `PollVotesQuery.userId` and `FeedQuery.activitySelectorOptions`, which the API no longer accepts [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Deprecate `UserData.revokeTokensIssuedBefore` and `ReactionGroupData.sumScores`, which the API no longer returns [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)
- Rename some generated models, for example `ReactionGroupResponse` -> `FeedsReactionGroupResponse`. The old names are deprecated [#83](https://github.com/GetStream/stream-feeds-swift/pull/83)

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
