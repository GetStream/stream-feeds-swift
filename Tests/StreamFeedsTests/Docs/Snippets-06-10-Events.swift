//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import StreamFeeds
import SwiftUI
import UIKit

enum Snippets_06_10_Events {
    class MyViewController: UIViewController {
        private var cancellables = Set<AnyCancellable>()
        let feedsClient: FeedsClient

        init(feedsClient: FeedsClient) {
            self.feedsClient = feedsClient
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            setupEventListening()
        }

        private func setupEventListening() {
            feedsClient.eventPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] event in
                    self?.handleEvent(event)
                }
                .store(in: &cancellables)
        }

        private func handleEvent(_ event: Event) {
            switch event {
            case let activityEvent as ActivityAddedEvent:
                print("📝 New activity: \(activityEvent.activity.id)")
                updateFeedUI()

            case let pollEvent as PollClosedFeedEvent:
                print("📊 Poll closed: \(pollEvent.poll.id)")
                refreshPollData()

            case let commentEvent as CommentAddedEvent:
                print("💬 New comment: \(commentEvent.comment.id)")
                updateCommentsUI()

            case let reactionEvent as ActivityReactionAddedEvent:
                print("👍 Reaction added: \(reactionEvent.reaction.type)")
                updateReactionsUI()

            case let followEvent as FollowCreatedEvent:
                print("👥 New follow: \(followEvent.follow.targetFeed.feed)")
                updateFollowCount()

            case let bookmarkEvent as BookmarkAddedEvent:
                print("🔖 Bookmark added: \(bookmarkEvent.bookmark.objectId)")
                updateBookmarksUI()

            case let feedEvent as FeedCreatedEvent:
                print("📋 Feed created: \(feedEvent.fid)")
                refreshFeedList()

            case let connectedEvent as ConnectedEvent:
                print("🔗 Connected to Stream with ID: \(connectedEvent.connectionId)")

            case let errorEvent as ConnectionErrorEvent:
                print("❌ Connection error: \(errorEvent.error)")
                handleConnectionError()

            default:
                print("📡 Received event: \(type(of: event))")
            }
        }
    }

    class ActivityHandler {
        private var cancellables = Set<AnyCancellable>()
        let feedsClient: FeedsClient

        init(feedsClient: FeedsClient) {
            self.feedsClient = feedsClient
            setupActivityListeners()
        }

        private func setupActivityListeners() {
            // Listen only to activity added events
            feedsClient.eventPublisher(for: ActivityAddedEvent.self)
                .sink { [weak self] activityEvent in
                    print("New activity: \(activityEvent.activity.id)")
                    self?.handleNewActivity(activityEvent)
                }
                .store(in: &cancellables)

            // Listen only to activity updated events
            feedsClient.eventPublisher(for: ActivityUpdatedEvent.self)
                .sink { [weak self] activityEvent in
                    print("Activity updated: \(activityEvent.activity.id)")
                    self?.handleActivityUpdate(activityEvent)
                }
                .store(in: &cancellables)

            // Listen only to activity deleted events
            feedsClient.eventPublisher(for: ActivityDeletedEvent.self)
                .sink { [weak self] activityEvent in
                    print("Activity deleted: \(activityEvent.activity.id)")
                    self?.handleActivityDeletion(activityEvent)
                }
                .store(in: &cancellables)
        }

        private func handleNewActivity(_ event: ActivityAddedEvent) {
            // Handle new activity
        }

        private func handleActivityUpdate(_ event: ActivityUpdatedEvent) {
            // Handle activity update
        }

        private func handleActivityDeletion(_ event: ActivityDeletedEvent) {
            // Handle activity deletion
        }
    }

    class FeedManager {
        private var cancellables = Set<AnyCancellable>()
        let feedsClient: FeedsClient

        init(feedsClient: FeedsClient) {
            self.feedsClient = feedsClient
            setupEventListeners()
        }

        private func setupEventListeners() {
            // Activity events
            feedsClient.eventPublisher(for: ActivityAddedEvent.self)
                .sink { [weak self] event in
                    self?.handleActivityAdded(event)
                }
                .store(in: &cancellables)

            // Comment events
            feedsClient.eventPublisher(for: CommentAddedEvent.self)
                .sink { [weak self] event in
                    self?.handleCommentAdded(event)
                }
                .store(in: &cancellables)

            // Poll events
            feedsClient.eventPublisher(for: PollVoteCastedFeedEvent.self)
                .sink { [weak self] event in
                    self?.handlePollVote(event)
                }
                .store(in: &cancellables)

            // Connection events
            feedsClient.eventPublisher(for: ConnectedEvent.self)
                .sink { [weak self] event in
                    self?.handleConnection(event)
                }
                .store(in: &cancellables)
        }
    }

    struct FeedView: View {
        @ObservedObject var viewModel: FeedViewModel
        @State private var cancellables = Set<AnyCancellable>()

        var body: some View {
            List(viewModel.activities) { activity in
                ActivityRow(activity: activity)
            }
            .onAppear {
                setupEventListening()
            }
            .onDisappear {
                cancellables.removeAll()
            }
        }

        private func setupEventListening() {
            viewModel.feedsClient.eventPublisher(for: ActivityAddedEvent.self)
                .receive(on: DispatchQueue.main)
                .sink { event in
                    viewModel.addActivity(event.activity)
                }
                .store(in: &cancellables)

            viewModel.feedsClient.eventPublisher(for: ActivityUpdatedEvent.self)
                .receive(on: DispatchQueue.main)
                .sink { event in
                    viewModel.updateActivity(event.activity)
                }
                .store(in: &cancellables)
        }
    }
}

// MARK: - App code the snippets call

extension Snippets_06_10_Events.MyViewController {
    func updateFeedUI() {}
    func refreshPollData() {}
    func updateCommentsUI() {}
    func updateReactionsUI() {}
    func updateFollowCount() {}
    func updateBookmarksUI() {}
    func refreshFeedList() {}
    func handleConnectionError() {}
}

extension Snippets_06_10_Events.FeedManager {
    func handleActivityAdded(_ event: ActivityAddedEvent) {}
    func handleCommentAdded(_ event: CommentAddedEvent) {}
    func handlePollVote(_ event: PollVoteCastedFeedEvent) {}
    func handleConnection(_ event: ConnectedEvent) {}
}

extension Snippets_06_10_Events {
    final class FeedViewModel: ObservableObject {
        @Published var activities: [ActivityData] = []
        let feedsClient: FeedsClient

        init(feedsClient: FeedsClient) {
            self.feedsClient = feedsClient
        }

        func addActivity(_ activity: ActivityResponse) {}
        func updateActivity(_ activity: ActivityResponse) {}
    }

    struct ActivityRow: View {
        let activity: ActivityData

        var body: some View {
            Text(activity.text ?? "")
        }
    }
}
