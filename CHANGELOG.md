# StreamFeeds iOS SDK CHANGELOG

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

# Upcoming

### 🔄 Changed

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
