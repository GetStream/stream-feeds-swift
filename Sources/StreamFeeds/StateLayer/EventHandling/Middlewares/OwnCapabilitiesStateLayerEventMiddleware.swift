//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// Extracts own capabilities from events and saves it to the shared
/// store in the capabilities repository.
final class OwnCapabilitiesStateLayerEventMiddleware: StateLayerEventMiddleware {
    private let sendEvent: @Sendable (StateLayerEvent) async -> Void
    let ownCapabilitiesRepository: OwnCapabilitiesRepository
    
    init(ownCapabilitiesRepository: OwnCapabilitiesRepository, sendEvent: @escaping @Sendable (StateLayerEvent) async -> Void) {
        self.ownCapabilitiesRepository = ownCapabilitiesRepository
        self.sendEvent = sendEvent
    }
    
    // MARK: - Processing Events
    
    /// Adds own capabilities to web-socket added events and extracts own capabilities from local events.
    ///
    /// - Note: Added events are only enriched because state-layer merged WS event data by keeping own fields. Therefore,
    /// updated events do not need to have capabilities correctly set. Secondly, state-layer uses feedOwnCapabilitiesUpdated
    /// to automatically apply updated capablities.
    func willPublish(_ event: StateLayerEvent, from source: StateLayerEventPublisher.EventSource) async -> StateLayerEvent {
        switch source {
        case .webSocket:
            switch event {
            case .activityAdded(let activityData, let feedId):
                guard let capabilitiesMap = await cachedCapabilities(for: activityData) else { break }
                return .activityAdded(activityData.withFeedOwnCapabilities(from: capabilitiesMap), feedId)
            case .bookmarkAdded(let bookmarkData):
                guard let capabilitiesMap = await cachedCapabilities(for: bookmarkData.activity) else { break }
                return .bookmarkAdded(bookmarkData.withFeedOwnCapabilities(from: capabilitiesMap))
            case .feedAdded(let feedData, let feedId):
                guard let capabilitiesMap = await cachedCapabilities(for: feedData.feed) else { break }
                return .feedAdded(feedData.withFeedOwnCapabilities(from: capabilitiesMap), feedId)
            case .feedFollowAdded(let followData, let feedId):
                guard let capabilitiesMap = await cachedCapabilities(for: Set([followData.sourceFeed.feed, followData.targetFeed.feed])) else { break }
                return .feedFollowAdded(followData.withFeedOwnCapabilities(from: capabilitiesMap), feedId)
            default:
                return event
            }
        case .local:
            if let updated = ownCapabilitiesRepository.saveCapabilities(event.ownCapabilities) {
                await sendEvent(.feedOwnCapabilitiesUpdated(updated))
            }
        }
        return event
    }
    
    private func cachedCapabilities(for activity: ActivityData) async -> [FeedId: Set<FeedOwnCapability>]? {
        guard let feedData = activity.currentFeed else { return nil }
        return await cachedCapabilities(for: feedData.feed)
    }
    
    private func cachedCapabilities(for feed: FeedId) async -> [FeedId: Set<FeedOwnCapability>]? {
        guard let capabilities = ownCapabilitiesRepository.capabilities(for: feed) else {
            scheduleFetchingMissingCapabilities(for: [feed])
            return nil
        }
        return [feed: capabilities]
    }
    
    private func cachedCapabilities(for feeds: Set<FeedId>) async -> [FeedId: Set<FeedOwnCapability>]? {
        guard let capabilities = ownCapabilitiesRepository.capabilities(for: feeds) else {
            scheduleFetchingMissingCapabilities(for: feeds)
            return nil
        }
        return capabilities
    }
    
    // MARK: - Fetch Missing Capabilities
    
    /// Most of the case capabilities are cached since we read them from HTTP responses. One example where this
    /// can not be the case is where timeline feed is getting new activities from other feeds. For these,
    /// we still fill in capabilities automatically.
    ///
    /// - Note: This is not async function because we don't want suspend event handling while fetching additional capabilities
    private func scheduleFetchingMissingCapabilities(for feedIds: Set<FeedId>) {
        Task {
            do {
                let fetchedCapabilities = try await ownCapabilitiesRepository.getCapabilities(for: feedIds)
                _ = ownCapabilitiesRepository.saveCapabilities(fetchedCapabilities)
                // Here we explicitly send the update for making state-layer to fill in capabilities (default case is that newly inserted capabilities do not trigger local events)
                await sendEvent(.feedOwnCapabilitiesUpdated(fetchedCapabilities))
            } catch {
                log.error("Failed to fetch missing feed capabilities for number of feeds: \(feedIds.count)", error: error)
            }
        }
    }
}

private extension StateLayerEvent {
    var ownCapabilities: [FeedId: Set<FeedOwnCapability>] {
        guard let feedDatas, !feedDatas.isEmpty else { return [:] }
        return feedDatas.reduce(into: [FeedId: Set<FeedOwnCapability>](), { all, feedData in
            guard let capabilities = feedData.ownCapabilities, !capabilities.isEmpty else { return }
            all[feedData.feed] = capabilities
        })
    }
    
    var feedDatas: [FeedData]? {
        switch self {
        case .activityAdded(let activityData, _):
            return activityData.currentFeed.map { [$0] }
        case .activityUpdated(let activityData, _):
            return activityData.currentFeed.map { [$0] }
        case .activityBatchUpdate(let updates):
            return (updates.added + updates.updated).compactMap(\.currentFeed)
        case .activityReactionAdded(_, let activityData, _):
            return activityData.currentFeed.map { [$0] }
        case .activityReactionDeleted(_, let activityData, _):
            return activityData.currentFeed.map { [$0] }
        case .activityReactionUpdated(_, let activityData, _):
            return activityData.currentFeed.map { [$0] }
        case .activityPinned(let activityPinData, _):
            return activityPinData.activity.currentFeed.map { [$0] }
        case .activityUnpinned(let activityPinData, _):
            return activityPinData.activity.currentFeed.map { [$0] }
        case .bookmarkAdded(let bookmarkData):
            return bookmarkData.activity.currentFeed.map { [$0] }
        case .bookmarkDeleted(let bookmarkData):
            return bookmarkData.activity.currentFeed.map { [$0] }
        case .bookmarkUpdated(let bookmarkData):
            return bookmarkData.activity.currentFeed.map { [$0] }
        case .commentAdded(_, let activityData, _):
            return activityData.currentFeed.map { [$0] }
        case .feedAdded(let feedData, _):
            return [feedData]
        case .feedUpdated(let feedData, _):
            return [feedData]
        case .feedFollowAdded(let followData, _):
            return [followData.sourceFeed, followData.targetFeed]
        case .feedFollowDeleted(let followData, _):
            return [followData.sourceFeed, followData.targetFeed]
        case .feedFollowUpdated(let followData, _):
            return [followData.sourceFeed, followData.targetFeed]
        case .activityMarked, .activityDeleted,
             .bookmarkFolderDeleted, .bookmarkFolderUpdated,
             .commentDeleted, .commentUpdated, .commentsAddedBatch,
             .commentReactionAdded, .commentReactionDeleted, .commentReactionUpdated,
             .pollDeleted, .pollUpdated, .pollVoteCasted, .pollVoteChanged, .pollVoteDeleted,
             .feedDeleted,
             .feedGroupDeleted, .feedGroupUpdated,
             .feedMemberAdded, .feedMemberDeleted, .feedMemberUpdated, .feedMemberBatchUpdate,
             .notificationFeedUpdated,
             .userUpdated,
             .feedOwnCapabilitiesUpdated:
            return nil
        }
    }
}
