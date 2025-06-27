# StreamFeeds iOS

This is the official iOS SDK for StreamFeeds, a platform for building apps with activity feeds support. The repository includes a low-level SDK that communicates with Stream's backend, as well as a demo app that showcases how to use it.

## What is Stream?

Stream allows developers to rapidly deploy scalable feeds, chat messaging and video with an industry leading 99.999% uptime SLA guarantee.

Stream lets you build **activity feeds at scale**. The largest apps on Stream have over **100 M+ users**.
V3 keeps that scalability while giving you more flexibility over the content shown in your feed.

## What’s new in Feeds V3

- **For-You feed**: Most modern apps combine a “For You” feed with a regular “Following” feed. V3 introduces **activity selectors** so you can:
  - surface popular activities
  - show activities near the user
  - match activities to a user’s interests
  - mix-and-match these selectors to build an engaging personalized feed.

- **Performance**: 20–30 % faster flat feeds. Major speedups for aggregation & ranking (full benchmarks coming soon)

- **Client-side SDKs**

- **Activity filtering**: Filter activity feeds with almost no hit to performance

- **Comments**: Voting, ranking, threading, images, URL previews, @mentions & notifications. Basically all the features of Reddit style commenting systems.

- **Advanced feed features**: 
  - Activity expiration
  - visibility controls 
  - feed visibility levels
  - feed members
  - bookmarking
  - follow-approval flow
  - stories support.

- **Search & queries**: Activity search, **query activities**, and **query feeds** endpoints.

- **Modern essentials**: 
  - Permissions
  - OpenAPI spec
  - GDPR endpoints
  - realtime WebSocket events
  - push notifications
  - “own capabilities” API.

## 🚀 Getting Started

### Installation

The Swift SDK can be installed using Swift Package Manager, if you are starting a new project we always recommend using the latest release. 

Releases and changes are published on the [GitHub releases page](https://github.com/GetStream/stream-feeds-swift/releases).

**Add the SDK to your project**

To add `StreamFeeds` SDK, open Xcode and follow these steps:

- In Xcode, go to File -> "Add Packages…"
- Paste the URL [**https://github.com/GetStream/stream-feeds-swift.git**](https://github.com/GetStream/stream-feeds-swift.git)
- In the option "Dependency Rule" choose "Branch," in the single text input next to it, enter "main"
- Choose "Add Package" and wait for the dialog to complete.
- Select `StreamFeeds` and add it to your target.

### Basic Usage

To get started, you need to create a `FeedsClient` with your API key and a token. 

Afterwards, it's pretty straightforward to start adding feeds and activities.

Check our docs for more details.

```swift
import StreamCore
import StreamFeeds

// Initialize the client
let client = FeedsClient(
    apiKey: APIKey("<your_api_key>"),
    user: User(id: "john"),
    token: "<user_token>"
)

// Create a feed (or get its data if exists)
let feed = client.feed(group: "user", id: "john")
try await feed.getOrCreate()

// Add activity
let activity = try await feed.addActivity(
    request: .init(
        text: "Hello, Stream Feeds!",
        type: "post"
    )
)
```

## 📖 Key Concepts

### Activities

Activities are the core content units in Stream Feeds. They can represent posts, photos, videos, polls, and any custom content type you define.

### Feeds

Feeds are collections of activities. They can be personal feeds, timeline feeds, notification feeds, or custom feeds for your specific use case.

### Real-time Updates

Stream Feeds provides real-time updates through WebSocket connections, ensuring your app stays synchronized with the latest content.

### Social Features

Built-in support for reactions, comments, bookmarks, and polls makes it easy to build engaging social experiences.

## 👩‍💻 Free for Makers 👨‍💻

Stream is free for most side and hobby projects. To qualify, your project/company needs to have < 5 team members and < $10k in monthly revenue. Makers get $100 in monthly credit for video for free.