//
// Copyright © 2025 Stream.io Inc. All rights reserved.
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
}
