//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension MemberListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: MemberListState.ChangeHandlers
        private let feed: FeedId
        
        init(feed: FeedId, subscribing events: WSEventsSubscribing, handlers: MemberListState.ChangeHandlers) {
            self.handlers = handlers
            self.feed = feed
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as FeedMemberRemovedEvent:
                guard event.fid == feed.rawValue else { return }
                await handlers.memberRemoved(event.memberId)
            case let event as FeedMemberUpdatedEvent:
                guard event.fid == feed.rawValue else { return }
                await handlers.memberUpdated(event.member.toModel())
            default:
                break
            }
        }
    }
}
