//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// A centralized publisher for events state-layer uses.
///
/// Reduces the amount of data model conversions which is done once per event data.
/// Ensures that observation handlers run on a background thread allowing additional
/// filtering before consuming the event on the main thread.
final class StateLayerEventPublisher: WSEventsSubscriber, Sendable {
    private let subscriptions = AllocatedUnfairLock<[UUID: @Sendable (StateLayerEvent) async -> Void]>([:])
    private let middlewares = AllocatedUnfairLock([StateLayerEventMiddleware]())
    
    func addMiddlewares(_ additionalMiddlewares: [StateLayerEventMiddleware]) {
        middlewares.withLock { $0.append(contentsOf: additionalMiddlewares) }
    }
    
    /// Send individual events to all the subscribers.
    ///
    /// Triggered by incoming web-socket events and manually after API calls.
    ///
    /// - Parameter event: The state layer change event.
    func sendEvent(_ event: StateLayerEvent, source: EventSource = .local) async {
        var event = event
        for middleware in middlewares.value {
            event = await middleware.willPublish(event, from: source, with: self)
        }
        let handlers = Array(subscriptions.value.values)
        await withTaskGroup(of: Void.self) { [event] group in
            for handler in handlers {
                group.addTask {
                    await handler(event)
                }
            }
        }
    }
    
    func subscribe(_ handler: @escaping @Sendable (StateLayerEvent) async -> Void) -> Subscription {
        let id = UUID()
        subscriptions.withLock { $0[id] = handler }
        return Subscription { [weak self] in
            self?.unsubscribe(id)
        }
    }
    
    private func unsubscribe(_ id: UUID) {
        subscriptions.withLock { $0.removeValue(forKey: id) }
    }
    
    // MARK: - WSEventsSubscriber
    
    func onEvent(_ event: any Event) async {
        guard let stateLayerEvent = StateLayerEvent(event: event) else { return }
        await sendEvent(stateLayerEvent, source: .webSocket)
        
        switch stateLayerEvent {
        case .activityAdded(let activityData, let eventFeedId):
            // Parent does not get WS update, but reposting updates its data (e.g. share count)
            if let parent = activityData.parent {
                await sendEvent(.activityUpdated(parent, eventFeedId))
            }
        default:
            break
        }
    }
}

extension StateLayerEventPublisher {
    enum EventSource {
        case webSocket, local
    }
}

protocol StateLayerEventMiddleware: Sendable {
    func willPublish(_ event: StateLayerEvent, from source: StateLayerEventPublisher.EventSource, with eventPublisher: StateLayerEventPublisher) async -> StateLayerEvent
}

extension StateLayerEventPublisher {
    final class Subscription: Sendable {
        private let cancel: @Sendable () -> Void
        
        init(cancel: @escaping @Sendable () -> Void) {
            self.cancel = cancel
        }
        
        deinit {
            cancel()
        }
    }
}
