//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// Extracts own capabilities from events and saves it to the shared
/// store in the capabilities repository.
final class OwnCapabilitiesStateLayerEventMiddleware: StateLayerEventMiddleware {
    let ownCapabilitiesRepository: OwnCapabilitiesRepository
    
    init(ownCapabilitiesRepository: OwnCapabilitiesRepository) {
        self.ownCapabilitiesRepository = ownCapabilitiesRepository
    }
    
    // MARK: - Processing Events
    
    /// Adds own capabilities to web-socket added events and extracts own capabilities from local events.
    func willPublish(_ event: StateLayerEvent, from source: StateLayerEventPublisher.EventSource, with eventPublisher: StateLayerEventPublisher) async -> StateLayerEvent {
        switch source {
        case .webSocket:
            switch event {
            case .activityAdded(let activityData, let feedId):
                guard let capabilitiesMap = await updatedCapabilities(for: activityData) else { break }
                return .activityAdded(activityData.withFeedOwnCapabilities(from: capabilitiesMap), feedId)
            case .bookmarkAdded(let bookmarkData):
                guard let capabilitiesMap = await updatedCapabilities(for: bookmarkData.activity) else { break }
                return .bookmarkAdded(bookmarkData.withFeedOwnCapabilities(from: capabilitiesMap))
            case .feedAdded(let feedData, let feedId):
                guard let capabilitiesMap = await updatedCapabilities(for: feedData.feed) else { break }
                return .feedAdded(feedData.withFeedOwnCapabilities(from: capabilitiesMap), feedId)
            case .feedFollowAdded(let followData, let feedId):
                guard let capabilitiesMap = await updatedCapabilities(for: Set([followData.sourceFeed.feed, followData.targetFeed.feed])) else { break }
                return .feedFollowAdded(followData.withFeedOwnCapabilities(from: capabilitiesMap), feedId)
            default:
                return event
            }
        case .local:
            if let updated = ownCapabilitiesRepository.saveCapabilities(event.ownCapabilities) {
                await eventPublisher.sendEvent(.feedOwnCapabilitiesUpdated(updated))
            }
        }
        return event
    }
    
    private func updatedCapabilities(for activity: ActivityData) async -> [FeedId: Set<FeedOwnCapability>]? {
        guard let feedData = activity.currentFeed else { return nil }
        return await updatedCapabilities(for: feedData.feed)
    }
    
    private func updatedCapabilities(for feed: FeedId) async -> [FeedId: Set<FeedOwnCapability>]? {
        await updatedCapabilities(for: Set(arrayLiteral: feed))
    }
    
    private func updatedCapabilities(for feeds: Set<FeedId>) async -> [FeedId: Set<FeedOwnCapability>]? {
        do {
            return try await ownCapabilitiesRepository.capabilities(for: feeds)
        } catch {
            log.error("Failed fetching capabilities for enriching events", subsystems: .httpRequests, error: error)
            return nil
        }
    }
}

private extension StateLayerEvent {
    var ownCapabilities: [FeedId: Set<FeedOwnCapability>] {
        guard let feedDatas else { return [:] }
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
