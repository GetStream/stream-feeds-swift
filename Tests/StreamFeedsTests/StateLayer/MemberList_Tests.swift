//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct MemberList_Tests {
    // MARK: - Actions

    @Test func getUpdatesState() async throws {
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: FeedId(rawValue: "user:test")))
        let members = try await memberList.get()
        let stateMembers = await memberList.state.members
        #expect(members.count == 2)
        #expect(stateMembers.count == 2)
        #expect(stateMembers.map(\.id) == ["member-1", "member-2"])
        #expect(members.map(\.id) == stateMembers.map(\.id))
        await #expect(memberList.state.canLoadMore == true)
        await #expect(memberList.state.pagination?.next == "next-cursor")
    }

    @Test func queryMoreMembersUpdatesState() async throws {
        let client = defaultClientWithMemberResponses([
            QueryFeedMembersResponse.dummy(
                members: [
                    .dummy(user: .dummy(id: "member-3", name: "Third Member")),
                    .dummy(user: .dummy(id: "member-4", name: "Fourth Member"))
                ],
                next: "next-cursor-2"
            )
        ])
        let memberList = client.memberList(for: MembersQuery(feed: FeedId(rawValue: "user:test")))

        // Initial load
        _ = try await memberList.get()
        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["member-1", "member-2"])

        // Load more
        let moreMembers = try await memberList.queryMoreMembers()
        let updatedState = await memberList.state.members
        #expect(moreMembers.count == 2)
        #expect(moreMembers.map(\.id) == ["member-3", "member-4"])
        #expect(updatedState.count == 4)
        // The members should be sorted by createdAt in ascending order (oldest first)
        #expect(updatedState.map(\.id) == ["member-3", "member-4", "member-1", "member-2"])
        await #expect(memberList.state.canLoadMore == true)
        await #expect(memberList.state.pagination?.next == "next-cursor-2")
    }

    @Test func queryMoreMembersWhenNoMoreMembersReturnsEmpty() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                QueryFeedMembersResponse.dummy(
                    members: [
                        .dummy(user: .dummy(id: "member-1", name: "First Member")),
                        .dummy(user: .dummy(id: "member-2", name: "Second Member"))
                    ],
                    next: nil
                )
            ])
        )
        let memberList = client.memberList(for: MembersQuery(feed: FeedId(rawValue: "user:test")))

        // Initial load
        _ = try await memberList.get()

        // Check pagination state
        let pagination = await memberList.state.pagination
        #expect(pagination?.next == nil)

        // Try to load more when no more available - should return empty array
        let moreMembers = try await memberList.queryMoreMembers()
        #expect(moreMembers.isEmpty)
    }

    @Test func getWithEmptyResponseUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                QueryFeedMembersResponse.dummy(
                    members: [],
                    next: nil
                )
            ])
        )
        let memberList = client.memberList(for: MembersQuery(feed: FeedId(rawValue: "user:test")))
        let members = try await memberList.get()
        let stateMembers = await memberList.state.members
        #expect(members.isEmpty)
        #expect(stateMembers.isEmpty)
        await #expect(memberList.state.canLoadMore == false)
        await #expect(memberList.state.pagination?.next == nil)
    }

    // MARK: - WebSocket Events

    @Test func memberUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: FeedId(rawValue: "user:test")))
        try await memberList.get()

        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "member-1" }?.user.name == "First Member")

        // Send member updated event
        await client.eventsMiddleware.sendEvent(
            FeedMemberUpdatedEvent.dummy(
                fid: "user:test",
                member: .dummy(user: .dummy(id: "member-1", name: "Updated First Member"))
            )
        )

        let updatedState = await memberList.state.members
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "member-1" }?.user.name == "Updated First Member")
        #expect(updatedState.first { $0.id == "member-2" }?.user.name == "Second Member")
    }

    @Test func memberRemovedEventUpdatesState() async throws {
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: FeedId(rawValue: "user:test")))
        try await memberList.get()

        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["member-1", "member-2"])

        // Send member removed event
        await client.eventsMiddleware.sendEvent(
            FeedMemberRemovedEvent.dummy(
                fid: "user:test",
                memberId: "member-1"
            )
        )

        let updatedState = await memberList.state.members
        #expect(updatedState.count == 1)
        #expect(updatedState.map(\.id) == ["member-2"])
    }

    @Test func memberUpdatedEventForUnrelatedFeedDoesNotUpdateState() async throws {
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: FeedId(rawValue: "user:test")))
        try await memberList.get()

        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "member-1" }?.user.name == "First Member")

        // Send member updated event for unrelated feed
        await client.eventsMiddleware.sendEvent(
            FeedMemberUpdatedEvent.dummy(
                fid: "user:other",
                member: .dummy(user: .dummy(id: "member-1", name: "Updated Member"))
            )
        )

        let updatedState = await memberList.state.members
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "member-1" }?.user.name == "First Member")
        #expect(updatedState.first { $0.id == "member-2" }?.user.name == "Second Member")
    }

    @Test func memberRemovedEventForUnrelatedFeedDoesNotUpdateState() async throws {
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: FeedId(rawValue: "user:test")))
        try await memberList.get()

        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["member-1", "member-2"])

        // Send member removed event for unrelated feed
        await client.eventsMiddleware.sendEvent(
            FeedMemberRemovedEvent.dummy(
                fid: "user:other",
                memberId: "member-1"
            )
        )

        let updatedState = await memberList.state.members
        #expect(updatedState.count == 2)
        #expect(updatedState.map(\.id) == ["member-1", "member-2"])
    }

    // MARK: - Helper Methods

    private func defaultClientWithMemberResponses(
        _ additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryFeedMembersResponse.dummy(
                        members: [
                            .dummy(user: .dummy(id: "member-1", name: "First Member")),
                            .dummy(user: .dummy(id: "member-2", name: "Second Member"))
                        ],
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
