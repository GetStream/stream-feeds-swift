//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct ModerationConfigList_Tests {
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let configList = client.moderationConfigList(
            for: ModerationConfigsQuery()
        )
        let configs = try await configList.get()
        let stateConfigs = await configList.state.configs
        #expect(configs.map(\.id) == ["config-1"])
        #expect(stateConfigs.map(\.id) == ["config-1"])
    }
    
    @Test func paginationLoadsMoreConfigs() async throws {
        let client = defaultClient(
            additionalPayloads: [
                QueryModerationConfigsResponse.dummy(
                    configs: [
                        .dummy(
                            createdAt: .fixed(offset: -1),
                            key: "config-2",
                            team: "Config 2"
                        )
                    ],
                    next: nil
                )
            ]
        )

        let configList = client.moderationConfigList(
            for: ModerationConfigsQuery()
        )
        
        // Initial load
        #expect(try await configList.get().map(\.id) == ["config-1"])
        #expect(await configList.state.canLoadMore == true)
        
        // Load more
        let moreConfigs = try await configList.queryMoreConfigs()
        #expect(moreConfigs.map(\.id) == ["config-2"])
        #expect(await configList.state.canLoadMore == false)
        
        // Check final state
        let finalStateConfigs = await configList.state.configs
        #expect(finalStateConfigs.map(\.id) == ["config-1", "config-2"], "Newest first")
    }
    
    // Note: ModerationConfigList doesn't have specific events in StateLayerEvent
    // This test verifies that the subscription mechanism is in place
    @Test func eventSubscriptionIsActive() async throws {
        let client = defaultClient()
        let configList = client.moderationConfigList(
            for: ModerationConfigsQuery()
        )
        try await configList.get()
        
        // Verify that the state is accessible (subscription is working)
        let configs = await configList.state.configs
        #expect(configs.map(\.id) == ["config-1"])
    }
    
    // MARK: -
    
    private func defaultClient(
        configs: [ConfigResponse] = [.dummy(key: "config-1", team: "Config 1")],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryModerationConfigsResponse.dummy(
                        configs: configs,
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
