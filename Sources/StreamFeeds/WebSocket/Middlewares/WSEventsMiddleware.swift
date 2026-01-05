//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

final class WSEventsMiddleware: EventMiddleware, WSEventsSubscribing {
    private let subscribers = AllocatedUnfairLock(NSHashTable<AnyObject>.weakObjects())

    func handle(event: Event) -> Event? {
        Task { await sendEvent(event) }
        return event
    }
    
    func sendEvent(_ event: Event) async {
        let subscribers = subscribers.withLock { $0.allObjects.compactMap { $0 as? WSEventsSubscriber } }
        for subscriber in subscribers {
            await subscriber.onEvent(event)
        }
    }
    
    func add(subscriber: WSEventsSubscriber) {
        subscribers.withLock { $0.add(subscriber) }
    }
    
    func remove(subscriber: WSEventsSubscriber) {
        subscribers.withLock { $0.remove(subscriber) }
    }
    
    func removeAllSubscribers() {
        subscribers.withLock { $0.removeAllObjects() }
    }
}

protocol WSEventsSubscribing: Sendable {
    func add(subscriber: WSEventsSubscriber)
}

protocol WSEventsSubscriber: AnyObject {
    func onEvent(_ event: Event) async
}
