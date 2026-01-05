//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation

/// This is a repository which holds a shared state and manages
/// a map of feed id to capabilities.
final class OwnCapabilitiesRepository: Sendable {
    private let apiClient: DefaultAPI
    private let storage = AllocatedUnfairLock([FeedId: Set<FeedOwnCapability>]())
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    // MARK: - Get Capabilities
    
    /// Returns locally cached capabilities if available.
    func capabilities(for feed: FeedId) -> Set<FeedOwnCapability>? {
        self.capabilities(for: Set(arrayLiteral: feed))?[feed]
    }
    
    /// Returns locally cached capabilities if available.
    func capabilities(for feeds: Set<FeedId>) -> [FeedId: Set<FeedOwnCapability>]? {
        let cached = storage.withLock { storage in
            feeds.reduce(into: [FeedId: Set<FeedOwnCapability>](), { all, feedId in
                guard let cached = storage[feedId] else { return }
                all[feedId] = cached
            })
        }
        if cached.count == feeds.count {
            return cached
        }
        return nil
    }
    
    func getCapabilities(for feeds: Set<FeedId>) async throws -> [FeedId: Set<FeedOwnCapability>] {
        let response = try await apiClient.ownCapabilitiesBatch(ownCapabilitiesBatchRequest: OwnCapabilitiesBatchRequest(feeds: feeds.map(\.rawValue)))
        return Dictionary(uniqueKeysWithValues: response.capabilities.map { (FeedId(rawValue: $0), Set($1)) })
    }
    
    // MARK: - Saving Capabilities
    
    func saveCapabilities(_ newCapabilities: [FeedId: Set<FeedOwnCapability>]) -> [FeedId: Set<FeedOwnCapability>]? {
        guard !newCapabilities.isEmpty else { return nil }
        return storage.withLock { storage in
            // Find only the ones which had a state before
            let changed = newCapabilities.filter { storage[$0] != nil && storage[$0] != $1 }
            storage.merge(newCapabilities, uniquingKeysWith: { _, new in new })
            return changed
        }
    }
    
    func saveCapabilities(in feedDatas: [FeedData]) -> [FeedId: Set<FeedOwnCapability>]? {
        guard !feedDatas.isEmpty else { return nil }
        let all = feedDatas.reduce(into: [FeedId: Set<FeedOwnCapability>](), { all, feedData in
            guard let capabilities = feedData.ownCapabilities, !capabilities.isEmpty else { return }
            all[feedData.feed] = capabilities
        })
        return saveCapabilities(all)
    }
    
    func saveCapabilities(in feedData: FeedData?) -> [FeedId: Set<FeedOwnCapability>]? {
        saveCapabilities(in: [feedData].compactMap { $0 })
    }
}
