//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
@testable import StreamFeeds
import Testing

struct FeedsClient_Test {
    // MARK: - Reconnection Publisher Tests

    @Test func reconnectionPublisherEmitsOnReconnection() async throws {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))
        var reconnectionCount = 0

        let cancellable = client.reconnectionPublisher
            .sink { _ in
                reconnectionCount += 1
            }
        client.connectionSubject.withLock { subject in
            subject.send(.connecting)
            subject.send(.connected)
            subject.send(.disconnecting)
            subject.send(.disconnected(error: TestError()))
            subject.send(.connecting)
            subject.send(.connected) // This should trigger reconnection
        }

        #expect(reconnectionCount == 1)
        cancellable.cancel()
    }

    @Test func reconnectionPublisherDoesNotEmitOnInitialConnection() async throws {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))
        var reconnectionCount = 0

        let cancellable = client.reconnectionPublisher
            .sink { _ in
                reconnectionCount += 1
            }

        client.connectionSubject.withLock { subject in
            subject.send(.connecting)
            subject.send(.connected)
        }

        #expect(reconnectionCount == 0)
        cancellable.cancel()
    }

    @Test func reconnectionPublisherDoesNotEmitOnMultipleDisconnections() async throws {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))
        var reconnectionCount = 0

        let cancellable = client.reconnectionPublisher
            .sink { _ in
                reconnectionCount += 1
            }

        client.connectionSubject.withLock { subject in
            subject.send(.connected)
            subject.send(.disconnected(error: TestError()))
            subject.send(.connecting)
            subject.send(.disconnected(error: TestError()))
        }

        #expect(reconnectionCount == 0)
        cancellable.cancel()
    }

    @Test func reconnectionPublisherEmitsMultipleTimesOnMultipleReconnections() async throws {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))
        var reconnectionCount = 0

        let cancellable = client.reconnectionPublisher
            .sink { _ in
                reconnectionCount += 1
            }

        client.connectionSubject.withLock { subject in
            // First reconnection cycle
            subject.send(.connected)
            subject.send(.disconnected(error: TestError()))
            subject.send(.connecting)
            subject.send(.connected) // First reconnection

            // Second reconnection cycle
            subject.send(.disconnected(error: TestError()))
            subject.send(.connecting)
            subject.send(.connected) // Second reconnection
        }

        #expect(reconnectionCount == 2)
        cancellable.cancel()
    }

    @Test func reconnectionPublisherStateTransitions() async throws {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))
        var reconnectionCount = 0

        let cancellable = client.reconnectionPublisher
            .sink { _ in
                reconnectionCount += 1
            }

        client.connectionSubject.withLock { subject in
            // Pattern 1: Normal reconnection
            subject.send(.connected)
            subject.send(.disconnecting)
            subject.send(.disconnected(error: TestError()))
            subject.send(.connecting)
            subject.send(.connected) // Should trigger reconnection

            // Pattern 2: Quick disconnect/reconnect
            subject.send(.disconnected(error: TestError()))
            subject.send(.connected) // Should trigger reconnection
        }

        #expect(reconnectionCount == 2)
        cancellable.cancel()
    }

    // MARK: - Feed Creation Tests

    @Test func feedWithGroupAndId() {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))

        let feed = client.feed(group: "user", id: "john")

        // Test that feed is created with correct parameters
        #expect(feed.feed.group == "user")
        #expect(feed.feed.id == "john")
    }

    @Test func feedWithFeedId() {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))
        let feedId = FeedId(group: "timeline", id: "flat")

        let feed = client.feed(for: feedId)

        // Test that feed is created with correct parameters
        #expect(feed.feed.group == "timeline")
        #expect(feed.feed.id == "flat")
    }

    @Test func feedWithQuery() {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))
        let feedId = FeedId(group: "notification", id: "test")
        let query = FeedQuery(feed: feedId, activityLimit: 20)

        let feed = client.feed(for: query)

        // Test that feed is created with correct parameters
        #expect(feed.feed.group == "notification")
        #expect(feed.feed.id == "test")
    }

    // MARK: - Action Methods Tests

    @Test func addActivity() async throws {
        let mockResponse = AddActivityResponse.dummy()
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([mockResponse]))

        let activityRequest = AddActivityRequest(
            feeds: ["user:john"],
            type: "post"
        )

        let response = try await client.addActivity(request: activityRequest)
        #expect(response.id == mockResponse.activity.id)
    }

    @Test func upsertActivities() async throws {
        let mockResponse = UpsertActivitiesResponse(
            activities: [ActivityResponse.dummy()],
            duration: "1.23ms"
        )
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([mockResponse]))

        let activities = [
            ActivityRequest(
                feeds: ["user:john"],
                type: "post"
            )
        ]

        let response = try await client.upsertActivities(activities)
        #expect(response.count == mockResponse.activities.count)
    }

    @Test func deleteActivities() async throws {
        let mockResponse = DeleteActivitiesResponse(
            deletedIds: ["activity:123"],
            duration: "1.23ms"
        )
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([mockResponse]))

        let deleteRequest = DeleteActivitiesRequest(
            ids: ["activity:123"]
        )

        let response = try await client.deleteActivities(request: deleteRequest)
        #expect(response == Set(mockResponse.deletedIds))
    }

    // MARK: - Properties Tests

    @Test func clientProperties() {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))

        #expect(client.apiKey.apiKeyString == "UnitTests")
        #expect(client.user.id == "current-user-id")
        #expect(client.token.rawValue == "UnitTestingToken")
        #expect(client.userAuth == nil) // Initially nil until connect() is called
    }

    // MARK: - Initialization Tests

    @Test func convenienceInitializer() {
        let client = FeedsClient(
            apiKey: APIKey("TestKey"),
            user: User.dummy(id: "test-user"),
            token: "TestToken"
        )

        #expect(client.apiKey.apiKeyString == "TestKey")
        #expect(client.user.id == "test-user")
        #expect(client.token.rawValue == "TestToken")
    }

    // MARK: - Static Properties Tests

    @Test func endpointConfig() {
        // Test that endpointConfig is accessible and has expected properties
        let config = FeedsClient.endpointConfig
        #expect(!config.baseFeedsURL.isEmpty)
    }

    // MARK: - Internal State Tests

    @Test func connectionSubjectInitialState() {
        let client = FeedsClient.mock(apiTransport: APITransportMock.withPayloads([]))

        #expect(client.connectionSubject.value.value == .initialized)
    }
}
