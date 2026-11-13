//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_04_03_FeedMembers {
    var client: FeedsClient!
    var feed: Feed!

    func removingAMember() async throws {
        try await feed.updateFeedMembers(
            request: UpdateFeedMembersRequest(
                members: [FeedMemberRequest(userId: "john")],
                operation: .remove
            )
        )
    }

    func queryFeedMembers() async throws {
        let memberList = client.memberList(
            for: MembersQuery(
                feed: FeedId(group: "stock", id: "apple"),
                filter: .equal(.role, "moderator")
            )
        )
        try await memberList.get()
        // Observe memberList.state.members for updates
        let members = memberList.state.members

        suppressUnusedWarning(members)
    }
}
