//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

final class WSEventsMiddleware: EventMiddleware, WSEventsSubscribing {
    
    private let subscribers = AllocatedUnfairLock(NSHashTable<AnyObject>.weakObjects())

    func handle(event: Event) -> Event? {
        let allObjects = subscribers.withLock { $0.allObjects }
        for subscriber in allObjects {
            (subscriber as? WSEventsSubscriber)?.onEvent(event)
        }
        return event
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
    
    func onEvent(_ event: Event)
}
