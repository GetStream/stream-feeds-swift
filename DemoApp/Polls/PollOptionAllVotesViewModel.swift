//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import StreamFeeds
import SwiftUI

class PollOptionAllVotesViewModel: ObservableObject {
    
    let poll: PollInfo
    let option: PollOptionInfo
    let activity: Activity
    let feedsClient: FeedsClient
    
    @Published var pollVotes = [PollVoteInfo]()
    @Published var errorShown = false
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var animateChanges = false
    private var loadingVotes = false
        
    init(poll: PollInfo, option: PollOptionInfo, activity: Activity, feedsClient: FeedsClient) {
        self.poll = poll
        self.option = option
        self.activity = activity
        self.feedsClient = feedsClient
        refresh()
        
        // No animation for initial load
        $pollVotes
            .dropFirst()
            .map { _ in true }
            .assignWeakly(to: \.animateChanges, on: self)
            .store(in: &cancellables)
    }
    
    func refresh() {
        Task { @MainActor in
            do {
                self.pollVotes = try await activity.queryPollVotes(
                    pollId: poll.id,
                    userId: feedsClient.user.id,
                    request: .init(
                        filter: ["poll_id": .string(poll.id), "option_id": .string(option.id)]
                    )
                )
                if self.pollVotes.isEmpty {
                    self.loadVotes()
                }
            } catch {
                self.errorShown = true
            }
        }
    }
    
    func onAppear(vote: PollVoteInfo) {
        guard !loadingVotes,
              let index = pollVotes.firstIndex(where: { $0.id == vote.id }),
              index > pollVotes.count - 10 else { return }
        
        loadVotes()
    }
    
    //TODO: implement pagination
    private func loadVotes() {
//        loadingVotes = true
//
//        controller.loadMoreVotes { [weak self] error in
//            guard let self else { return }
//            self.loadingVotes = false
//            if error != nil {
//                self.errorShown = true
//            }
//        }
    }
}
