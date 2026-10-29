//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct StateRefetching_Tests {
    @Test func refetchesPagesUntilLoadedCountIsCovered() async throws {
        let source = PageSource(loadedCount: 30) { next in
            let cursor = (next.flatMap { Int($0.dropFirst("cursor-".count)) } ?? 0) + 1
            return PaginationResult(
                models: Array(repeating: 0, count: 10),
                pagination: PaginationData(next: "cursor-\(cursor)", previous: nil)
            )
        }
        try await source.refetch()
        #expect(source.requests.value == [nil, "cursor-1", "cursor-2"])
        #expect(source.refetched.value?.models.count == 30)
        #expect(source.refetched.value?.pagination.next == "cursor-3")
    }

    @Test func refetchesFirstPageWhenLessIsLoaded() async throws {
        let source = PageSource(loadedCount: 3) { _ in
            PaginationResult(models: Array(repeating: 0, count: 10), pagination: PaginationData(next: "cursor", previous: nil))
        }
        try await source.refetch()
        #expect(source.requests.value == [nil])
        #expect(source.refetched.value?.models.count == 10)
    }

    @Test func stopsWhenThereAreNoMorePages() async throws {
        let source = PageSource(loadedCount: 150) { _ in
            PaginationResult(models: [1, 2, 3], pagination: .empty)
        }
        try await source.refetch()
        #expect(source.requests.value.count == 1)
        #expect(source.refetched.value?.models == [1, 2, 3])
    }

    @Test func stopsOnEmptyPage() async throws {
        let source = PageSource(loadedCount: 150) { _ in
            PaginationResult(models: [], pagination: PaginationData(next: "cursor", previous: nil))
        }
        try await source.refetch()
        #expect(source.requests.value.count == 1)
        #expect(source.refetched.value?.models.isEmpty == true)
    }

    @Test func doesNotRefetchWhenNothingIsLoaded() async throws {
        let source = PageSource(loadedCount: nil) { _ in
            PaginationResult(models: [1], pagination: .empty)
        }
        try await source.refetch()
        #expect(source.requests.value.isEmpty)
        #expect(source.refetched.value == nil)
    }

    @Test func doesNotRefetchWhenAutomaticSyncIsDisabled() async throws {
        let transport = APITransportMock.withPayloads([
            QueryFollowsResponse.dummy(follows: [.dummy(targetFeed: .dummy(feed: "user:user-1"))]),
            QueryFollowsResponse.dummy(follows: [.dummy(targetFeed: .dummy(feed: "user:user-2"))])
        ])
        let client = FeedsClient.mock(apiTransport: transport, feedsConfig: FeedsConfig(isAutomaticSyncOnReconnectEnabled: false))
        let followList = client.followList(for: FollowsQuery())
        try await followList.get()

        client.simulateReconnection()
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(transport.responseResults.value.count == 1)
    }
}

private final class PageSource: StateRefetching {
    let loaded: Int?
    let makePage: @Sendable (String?) -> PaginationResult<Int>
    let requests = AllocatedUnfairLock<[String?]>([])
    let refetched = AllocatedUnfairLock<PaginationResult<Int>?>(nil)

    init(loadedCount: Int?, makePage: @escaping @Sendable (String?) -> PaginationResult<Int>) {
        loaded = loadedCount
        self.makePage = makePage
    }

    func loadedCount() async -> Int? {
        loaded
    }

    func fetchPage(next: String?) async throws -> PaginationResult<Int> {
        requests.withLock { $0.append(next) }
        return makePage(next)
    }

    func didRefetch(_ result: PaginationResult<Int>) async {
        refetched.withLock { $0 = result }
    }
}
