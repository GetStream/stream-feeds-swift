//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct OwnCapabilitiesStateLayerEventMiddleware_Tests {
    @Test func addCachedCapabilitiesToAddActivityEvent() async throws {
        let client = FeedsClient.mock(apiTransport: .withPayloads([]))
        _ = client.ownCapabilitiesRepository.saveCapabilities([FeedId(group: "user", id: "john"): [.readFeed]])
        
        let event = await withCheckedContinuation { continuation in
            let subscription = client.stateLayerEventPublisher.subscribe { event in
                guard case .activityAdded(let activity, _) = event else { return }
                continuation.resume(returning: activity)
            }
            
            Task {
                await client.eventsMiddleware.sendEvent(
                    ActivityAddedEvent.dummy(
                        activity: .dummy(currentFeed: .dummy(feed: "user:john")),
                        fid: "timeline:jane"
                    )
                )
                subscription.cancel()
            }
        }
        
        #expect(event.currentFeed?.ownCapabilities == [.readFeed])
    }
    
    @Test func addCachedCapabilitiesToBookmarkAddedEvent() async throws {
        let client = FeedsClient.mock(apiTransport: .withPayloads([]))
        _ = client.ownCapabilitiesRepository.saveCapabilities([FeedId(group: "user", id: "john"): [.readFeed, .addActivityBookmark]])
        
        let event = await withCheckedContinuation { continuation in
            let subscription = client.stateLayerEventPublisher.subscribe { event in
                guard case .bookmarkAdded(let bookmark) = event else { return }
                continuation.resume(returning: bookmark)
            }
            
            Task {
                await client.eventsMiddleware.sendEvent(
                    BookmarkAddedEvent.dummy(
                        bookmark: .dummy(activity: .dummy(currentFeed: .dummy(feed: "user:john")))
                    )
                )
                subscription.cancel()
            }
        }
        
        #expect(event.activity.currentFeed?.ownCapabilities == [.readFeed, .addActivityBookmark])
    }
    
    @Test func addCachedCapabilitiesToFeedAddedEvent() async throws {
        let client = FeedsClient.mock(apiTransport: .withPayloads([]))
        _ = client.ownCapabilitiesRepository.saveCapabilities([FeedId(group: "user", id: "john"): [.readFeed, .createFeed]])
        
        let event = await withCheckedContinuation { continuation in
            let subscription = client.stateLayerEventPublisher.subscribe { event in
                guard case .feedAdded(let feed, _) = event else { return }
                continuation.resume(returning: feed)
            }
            
            Task {
                await client.eventsMiddleware.sendEvent(
                    FeedCreatedEvent.dummy(
                        feed: .dummy(feed: "user:john"),
                        fid: "user:john"
                    )
                )
                subscription.cancel()
            }
        }
        
        #expect(event.ownCapabilities == [.readFeed, .createFeed])
    }
    
    @Test func addCachedCapabilitiesToFeedFollowAddedEvent() async throws {
        let client = FeedsClient.mock(apiTransport: .withPayloads([]))
        let sourceFeedId = FeedId(group: "user", id: "john")
        let targetFeedId = FeedId(group: "user", id: "jane")
        _ = client.ownCapabilitiesRepository.saveCapabilities([
            sourceFeedId: [.readFeed, .follow],
            targetFeedId: [.readFeed, .queryFollows]
        ])
        
        let event = await withCheckedContinuation { continuation in
            let subscription = client.stateLayerEventPublisher.subscribe { event in
                guard case .feedFollowAdded(let follow, _) = event else { return }
                continuation.resume(returning: follow)
            }
            
            Task {
                await client.eventsMiddleware.sendEvent(
                    FollowCreatedEvent.dummy(
                        follow: .dummy(
                            sourceFeed: .dummy(feed: sourceFeedId.rawValue),
                            targetFeed: .dummy(feed: targetFeedId.rawValue)
                        ),
                        fid: sourceFeedId.rawValue
                    )
                )
                subscription.cancel()
            }
        }
        
        #expect(event.sourceFeed.ownCapabilities == [.readFeed, .follow])
        #expect(event.targetFeed.ownCapabilities == [.readFeed, .queryFollows])
    }
    
    @Test func automaticallyFetchCapabilitiesOnWebSocketEventWhenNotLocallyCached() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                OwnCapabilitiesBatchResponse.dummy(capabilities: [
                    "user:john": [.addActivity, .readFeed]
                ])
            ])
        )
        var subscription: StateLayerEventPublisher.Subscription?
        let capabilities = await withCheckedContinuation { continuation in
            // Added event triggers internal fetch of capabilities which in turn sends capabilities updated event
            subscription = client.stateLayerEventPublisher.subscribe { event in
                guard case .feedOwnCapabilitiesUpdated(let capabilities) = event else { return }
                continuation.resume(returning: capabilities)
            }
            
            Task {
                await client.eventsMiddleware.sendEvent(
                    ActivityAddedEvent.dummy(
                        activity: .dummy(currentFeed: .dummy(feed: "user:john")),
                        fid: "timeline:jane"
                    )
                )
            }
        }
        
        #expect(capabilities[FeedId(group: "user", id: "john")] == [.addActivity, .readFeed])
        subscription?.cancel()
    }
    
    @Test func extractCapabilitiesFromLocalEvents() async throws {
        let client = FeedsClient.mock(apiTransport: .withPayloads([]))
        
        let makeActivityData: (String, Set<FeedOwnCapability>) -> ActivityData = { feedId, ownCapabilities in
            ActivityResponse.dummy(currentFeed: .dummy(feed: feedId, ownCapabilities: Array(ownCapabilities))).toModel()
        }
        let makeFeedData: (String, Set<FeedOwnCapability>) -> FeedData = { feedId, ownCapabilities in
            FeedResponse.dummy(feed: feedId, ownCapabilities: Array(ownCapabilities)).toModel()
        }
        let makeBookmarkData: (String, Set<FeedOwnCapability>) -> BookmarkData = { feedId, ownCapabilities in
            BookmarkResponse.dummy(activity: .dummy(currentFeed: .dummy(feed: feedId, ownCapabilities: Array(ownCapabilities)))).toModel()
        }
        let makeCommentData: (String) -> CommentData = { activityId in
            CommentResponse.dummy(objectId: activityId).toModel()
        }
        let makeReactionData: (String) -> FeedsReactionData = { activityId in
            FeedsReactionResponse.dummy(activityId: activityId).toModel()
        }
        let makeActivityPinData: (String, Set<FeedOwnCapability>) -> ActivityPinData = { feedId, ownCapabilities in
            ActivityPinResponse.dummy(
                activity: .dummy(currentFeed: .dummy(feed: feedId, ownCapabilities: Array(ownCapabilities))),
                feed: feedId
            ).toModel()
        }
        let makeFollowData: (String, String, Set<FeedOwnCapability>, Set<FeedOwnCapability>) -> FollowData = { sourceFeedId, targetFeedId, sourceCapabilities, targetCapabilities in
            FollowResponse.dummy(
                sourceFeed: .dummy(feed: sourceFeedId, ownCapabilities: Array(sourceCapabilities)),
                targetFeed: .dummy(feed: targetFeedId, ownCapabilities: Array(targetCapabilities))
            ).toModel()
        }
        
        var feedIdCounter = 1
        
        let user1FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user1Capabilities: Set<FeedOwnCapability> = [.readFeed, .addActivity]
        await client.stateLayerEventPublisher.sendEvent(.activityAdded(makeActivityData(user1FeedId.rawValue, user1Capabilities), user1FeedId), source: .local)
        feedIdCounter += 1
        
        let user2FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user2Capabilities: Set<FeedOwnCapability> = [.readFeed, .updateOwnActivity]
        await client.stateLayerEventPublisher.sendEvent(.activityUpdated(makeActivityData(user2FeedId.rawValue, user2Capabilities), user2FeedId), source: .local)
        feedIdCounter += 1
        
        let user3FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user3Capabilities: Set<FeedOwnCapability> = [.readFeed, .addActivityReaction, .addActivity]
        await client.stateLayerEventPublisher.sendEvent(.activityReactionAdded(makeReactionData("activity-1"), makeActivityData(user3FeedId.rawValue, user3Capabilities), user3FeedId), source: .local)
        feedIdCounter += 1
        
        let user4FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user4Capabilities: Set<FeedOwnCapability> = [.readFeed, .deleteOwnActivityReaction]
        await client.stateLayerEventPublisher.sendEvent(.activityReactionDeleted(makeReactionData("activity-2"), makeActivityData(user4FeedId.rawValue, user4Capabilities), user4FeedId), source: .local)
        feedIdCounter += 1
        
        let user5FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user5Capabilities: Set<FeedOwnCapability> = [.readFeed, .addActivityReaction]
        await client.stateLayerEventPublisher.sendEvent(.activityReactionUpdated(makeReactionData("activity-3"), makeActivityData(user5FeedId.rawValue, user5Capabilities), user5FeedId), source: .local)
        feedIdCounter += 1
        
        let user6FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user6Capabilities: Set<FeedOwnCapability> = [.readFeed, .pinActivity]
        await client.stateLayerEventPublisher.sendEvent(.activityPinned(makeActivityPinData(user6FeedId.rawValue, user6Capabilities), user6FeedId), source: .local)
        feedIdCounter += 1
        
        let user7FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user7Capabilities: Set<FeedOwnCapability> = [.readFeed, .pinActivity, .addActivity]
        await client.stateLayerEventPublisher.sendEvent(.activityUnpinned(makeActivityPinData(user7FeedId.rawValue, user7Capabilities), user7FeedId), source: .local)
        feedIdCounter += 1
        
        let user8FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user8Capabilities: Set<FeedOwnCapability> = [.readFeed, .addActivityBookmark]
        await client.stateLayerEventPublisher.sendEvent(.bookmarkAdded(makeBookmarkData(user8FeedId.rawValue, user8Capabilities)), source: .local)
        feedIdCounter += 1
        
        let user9FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user9Capabilities: Set<FeedOwnCapability> = [.readFeed, .deleteOwnActivityBookmark]
        await client.stateLayerEventPublisher.sendEvent(.bookmarkDeleted(makeBookmarkData(user9FeedId.rawValue, user9Capabilities)), source: .local)
        feedIdCounter += 1
        
        let user10FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user10Capabilities: Set<FeedOwnCapability> = [.readFeed, .updateOwnActivityBookmark]
        await client.stateLayerEventPublisher.sendEvent(.bookmarkUpdated(makeBookmarkData(user10FeedId.rawValue, user10Capabilities)), source: .local)
        feedIdCounter += 1
        
        let user11FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user11Capabilities: Set<FeedOwnCapability> = [.readFeed, .addComment]
        await client.stateLayerEventPublisher.sendEvent(.commentAdded(makeCommentData("activity-4"), makeActivityData(user11FeedId.rawValue, user11Capabilities), user11FeedId), source: .local)
        feedIdCounter += 1
        
        let user12FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user12Capabilities: Set<FeedOwnCapability> = [.readFeed, .createFeed]
        await client.stateLayerEventPublisher.sendEvent(.feedAdded(makeFeedData(user12FeedId.rawValue, user12Capabilities), user12FeedId), source: .local)
        feedIdCounter += 1
        
        let user13FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user13Capabilities: Set<FeedOwnCapability> = [.readFeed, .updateFeed]
        await client.stateLayerEventPublisher.sendEvent(.feedUpdated(makeFeedData(user13FeedId.rawValue, user13Capabilities), user13FeedId), source: .local)
        feedIdCounter += 1
        
        let user14FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user14Capabilities: Set<FeedOwnCapability> = [.readFeed, .follow]
        feedIdCounter += 1
        let user15FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user15Capabilities: Set<FeedOwnCapability> = [.readFeed, .queryFollows]
        await client.stateLayerEventPublisher.sendEvent(.feedFollowAdded(makeFollowData(user14FeedId.rawValue, user15FeedId.rawValue, user14Capabilities, user15Capabilities), user14FeedId), source: .local)
        feedIdCounter += 1
        
        let user16FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user16Capabilities: Set<FeedOwnCapability> = [.readFeed, .unfollow]
        feedIdCounter += 1
        let user17FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user17Capabilities: Set<FeedOwnCapability> = [.readFeed, .queryFollows]
        await client.stateLayerEventPublisher.sendEvent(.feedFollowDeleted(makeFollowData(user16FeedId.rawValue, user17FeedId.rawValue, user16Capabilities, user17Capabilities), user16FeedId), source: .local)
        feedIdCounter += 1
        
        let user18FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user18Capabilities: Set<FeedOwnCapability> = [.readFeed, .follow]
        feedIdCounter += 1
        let user19FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user19Capabilities: Set<FeedOwnCapability> = [.readFeed, .updateFeedFollowers]
        await client.stateLayerEventPublisher.sendEvent(.feedFollowUpdated(makeFollowData(user18FeedId.rawValue, user19FeedId.rawValue, user18Capabilities, user19Capabilities), user18FeedId), source: .local)
        feedIdCounter += 1
        
        let user20FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user20Capabilities: Set<FeedOwnCapability> = [.readFeed, .addActivity]
        feedIdCounter += 1
        let user21FeedId = FeedId(rawValue: "user:user\(feedIdCounter)")
        let user21Capabilities: Set<FeedOwnCapability> = [.readFeed, .updateOwnActivity]
        let batchUpdates = ModelUpdates<ActivityData>(
            added: [makeActivityData(user20FeedId.rawValue, user20Capabilities)],
            removedIds: [],
            updated: [makeActivityData(user21FeedId.rawValue, user21Capabilities)]
        )
        await client.stateLayerEventPublisher.sendEvent(.activityBatchUpdate(batchUpdates), source: .local)
        
        #expect(client.ownCapabilitiesRepository.capabilities(for: user1FeedId) == user1Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user2FeedId) == user2Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user3FeedId) == user3Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user4FeedId) == user4Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user5FeedId) == user5Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user6FeedId) == user6Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user7FeedId) == user7Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user8FeedId) == user8Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user9FeedId) == user9Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user10FeedId) == user10Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user11FeedId) == user11Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user12FeedId) == user12Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user13FeedId) == user13Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user14FeedId) == user14Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user15FeedId) == user15Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user16FeedId) == user16Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user17FeedId) == user17Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user18FeedId) == user18Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user19FeedId) == user19Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user20FeedId) == user20Capabilities)
        #expect(client.ownCapabilitiesRepository.capabilities(for: user21FeedId) == user21Capabilities)
    }
}
