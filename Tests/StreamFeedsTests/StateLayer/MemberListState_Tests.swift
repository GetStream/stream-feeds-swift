//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct MemberListState_Tests {
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
                    .dummy(id: "member-3", user: .dummy(id: "user-3")),
                    .dummy(id: "member-4", user: .dummy(id: "user-4"))
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
        await #expect(memberList.state.canLoadMore == true)
        await #expect(memberList.state.pagination?.next == "next-cursor-2")
    }

    // MARK: - WebSocket Events

    @Test func feedMemberUpdatedEventUpdatesState() async throws {
        let feedId = FeedId(rawValue: "user:test")
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: feedId))

        // Initial load
        _ = try await memberList.get()
        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "member-1" }?.user.id == "user-1")

        // Send feed member updated event
        let updatedMember = FeedMemberResponse.dummy(
            id: "member-1",
            user: .dummy(id: "user-1-updated")
        ).toModel()
        await client.stateLayerEventPublisher.sendEvent(.feedMemberUpdated(updatedMember, feedId))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await memberList.state.members
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "member-1" }?.user.id == "user-1-updated")
    }

    @Test func feedMemberDeletedEventUpdatesState() async throws {
        let feedId = FeedId(rawValue: "user:test")
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: feedId))

        // Initial load
        _ = try await memberList.get()
        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["member-1", "member-2"])

        // Send feed member deleted event
        await client.stateLayerEventPublisher.sendEvent(.feedMemberDeleted("member-1", feedId))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await memberList.state.members
        #expect(updatedState.count == 1)
        #expect(updatedState.map(\.id) == ["member-2"])
    }

    @Test func feedMemberBatchUpdateEventUpdatesState() async throws {
        let feedId = FeedId(rawValue: "user:test")
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: feedId))

        // Initial load
        _ = try await memberList.get()
        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["member-1", "member-2"])

        // Send feed member batch update event
        let updatedMember = FeedMemberResponse.dummy(
            id: "member-1",
            user: .dummy(id: "user-1-updated")
        ).toModel()
        let updates = ModelUpdates<FeedMemberData>(
            added: [],
            removedIds: ["member-2"],
            updated: [updatedMember]
        )
        await client.stateLayerEventPublisher.sendEvent(.feedMemberBatchUpdate(updates, feedId))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await memberList.state.members
        #expect(updatedState.count == 1)
        #expect(updatedState.first?.id == "member-1")
        #expect(updatedState.first?.user.id == "user-1-updated")
    }

    @Test func feedMemberEventForDifferentFeedIsIgnored() async throws {
        let feedId = FeedId(rawValue: "user:test")
        let otherFeedId = FeedId(rawValue: "user:other")
        let client = defaultClientWithMemberResponses()
        let memberList = client.memberList(for: MembersQuery(feed: feedId))

        // Initial load
        _ = try await memberList.get()
        let initialState = await memberList.state.members
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["member-1", "member-2"])

        // Send feed member updated event for different feed
        let updatedMember = FeedMemberResponse.dummy(
            id: "member-1",
            user: .dummy(id: "user-1-updated")
        ).toModel()
        await client.stateLayerEventPublisher.sendEvent(.feedMemberUpdated(updatedMember, otherFeedId))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await memberList.state.members
        #expect(updatedState.count == 2)
        #expect(updatedState.map(\.id) == ["member-1", "member-2"])
        #expect(updatedState.first { $0.id == "member-1" }?.user.id == "user-1") // Should not be updated
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
                            .dummy(id: "member-1", user: .dummy(id: "user-1")),
                            .dummy(id: "member-2", user: .dummy(id: "user-2"))
                        ],
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
