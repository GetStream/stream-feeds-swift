//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct StateRefetching_Tests {
    @Test func refetchesLoadedCountInPages() async throws {
        let source = PageSource(loadedCount: 150, refetchLimit: 10) { limit, next in
            PaginationResult(
                models: Array(repeating: 0, count: limit),
                pagination: PaginationData(next: next == nil ? "cursor-1" : "cursor-2", previous: nil)
            )
        }
        try await source.refetch()
        #expect(source.requests.value == [.init(limit: 100, next: nil), .init(limit: 50, next: "cursor-1")])
        #expect(source.refetched.value?.models.count == 150)
        #expect(source.refetched.value?.pagination.next == "cursor-2")
    }

    @Test func refetchesFirstPageWhenLessIsLoaded() async throws {
        let source = PageSource(loadedCount: 3, refetchLimit: 10) { _, _ in
            PaginationResult(models: [], pagination: .empty)
        }
        try await source.refetch()
        #expect(source.requests.value == [.init(limit: 10, next: nil)])
    }

    @Test func stopsWhenThereAreNoMorePages() async throws {
        let source = PageSource(loadedCount: 150, refetchLimit: nil) { _, _ in
            PaginationResult(models: [1, 2, 3], pagination: .empty)
        }
        try await source.refetch()
        #expect(source.requests.value.count == 1)
        #expect(source.refetched.value?.models == [1, 2, 3])
    }

    @Test func stopsOnEmptyPage() async throws {
        let source = PageSource(loadedCount: 150, refetchLimit: nil) { _, _ in
            PaginationResult(models: [], pagination: PaginationData(next: "cursor", previous: nil))
        }
        try await source.refetch()
        #expect(source.requests.value.count == 1)
        #expect(source.refetched.value?.models.isEmpty == true)
    }

    @Test func doesNotRefetchWhenNothingIsLoaded() async throws {
        let source = PageSource(loadedCount: nil, refetchLimit: nil) { _, _ in
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
    struct Request: Equatable, Sendable {
        let limit: Int
        let next: String?
    }

    let loaded: Int?
    let refetchLimit: Int?
    let makePage: @Sendable (Int, String?) -> PaginationResult<Int>
    let requests = AllocatedUnfairLock<[Request]>([])
    let refetched = AllocatedUnfairLock<PaginationResult<Int>?>(nil)

    init(loadedCount: Int?, refetchLimit: Int?, makePage: @escaping @Sendable (Int, String?) -> PaginationResult<Int>) {
        loaded = loadedCount
        self.refetchLimit = refetchLimit
        self.makePage = makePage
    }

    func loadedCount() async -> Int? {
        loaded
    }

    func fetchPage(limit: Int, next: String?) async throws -> PaginationResult<Int> {
        requests.withLock { $0.append(Request(limit: limit, next: next)) }
        return makePage(limit, next)
    }

    func didRefetch(_ result: PaginationResult<Int>) async {
        refetched.withLock { $0 = result }
    }
}
