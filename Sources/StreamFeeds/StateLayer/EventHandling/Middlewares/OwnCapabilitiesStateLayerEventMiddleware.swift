//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// Extracts own capabilities from events and saves it to the shared
/// store in the capabilities repository.
final class OwnCapabilitiesStateLayerEventMiddleware: StateLayerEventMiddleware {
    private let capabilitiesFetchSubject = AllocatedUnfairLock(PassthroughSubject<Set<FeedId>, Never>())
    private let disposableBag = DisposableBag()
    private let fetchDelay: Int
    private let sendEvent: @Sendable (StateLayerEvent) async -> Void
    let ownCapabilitiesRepository: OwnCapabilitiesRepository
    
    init(ownCapabilitiesRepository: OwnCapabilitiesRepository, fetchDelay: Int = 5, sendEvent: @escaping @Sendable (StateLayerEvent) async -> Void) {
        self.ownCapabilitiesRepository = ownCapabilitiesRepository
        self.fetchDelay = fetchDelay
        self.sendEvent = sendEvent
        subscribeToRefetch()
    }
    
    // MARK: - Processing Events
    
    /// Adds own capabilities to web-socket added events and extracts own capabilities from local events.
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
            capabilitiesFetchSubject.withLock { $0.send([feed]) }
            return nil
        }
        return [feed: capabilities]
    }
    
    private func cachedCapabilities(for feeds: Set<FeedId>) async -> [FeedId: Set<FeedOwnCapability>]? {
        guard let capabilities = ownCapabilitiesRepository.capabilities(for: feeds) else {
            capabilitiesFetchSubject.withLock { $0.send(feeds) }
            return nil
        }
        return capabilities
    }
    
    // MARK: - Fetch Missing Capabilities
    
    private func subscribeToRefetch() {
        capabilitiesFetchSubject.withLock { [disposableBag, fetchDelay, ownCapabilitiesRepository, sendEvent] subject in
            subject
                .collect(.byTimeOrCount(DispatchQueue.global(qos: .utility), .seconds(fetchDelay), 50))
                .map { $0.reduce(Set<FeedId>(), { $0.union($1) }) }
                .map { feedIds in
                    if let cachedIds = ownCapabilitiesRepository.capabilities(for: feedIds) {
                        return feedIds.subtracting(cachedIds.keys)
                    }
                    return feedIds
                }
                .asyncSink { feedIds in
                    do {
                        let fetchedCapabilities = try await ownCapabilitiesRepository.getCapabilities(for: feedIds)
                        _ = ownCapabilitiesRepository.saveCapabilities(fetchedCapabilities)
                        // Here we explicitly send the update for making state-layer to fill in capabilities (default case is that newly inserted capabilities do not trigger local events)
                        await sendEvent(.feedOwnCapabilitiesUpdated(fetchedCapabilities))
                    } catch {
                        log.error("Failed to fetch missing feed capabilities for number of feeds: \(feedIds.count)", error: error)
                    }
                }
                .store(in: disposableBag)
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
