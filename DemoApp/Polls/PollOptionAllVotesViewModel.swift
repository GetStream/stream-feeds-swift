//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import StreamFeeds
import SwiftUI

class PollOptionAllVotesViewModel: ObservableObject {
    
    let poll: PollResponseData
    let option: PollOptionResponseData
    let activity: Activity
    let feedsClient: FeedsClient
    
    @Published var pollVotes = [PollVoteResponseData]()
    @Published var errorShown = false
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var animateChanges = false
    private var loadingVotes = false
        
    init(poll: PollResponseData, option: PollOptionResponseData, activity: Activity, feedsClient: FeedsClient) {
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
                let response = try await activity.queryPollVotes(
                    pollId: poll.id,
                    userId: feedsClient.user.id,
                    queryPollVotesRequest: .init(
                        filter: ["poll_id": .string(poll.id), "option_id": .string(option.id)]
                    )
                )
                self.pollVotes = response.votes
                if self.pollVotes.isEmpty {
                    self.loadVotes()
                }
            } catch {
                self.errorShown = true
            }
        }
    }
    
    func onAppear(vote: PollVoteResponseData) {
        guard !loadingVotes,
              let index = pollVotes.firstIndex(where: { $0 == vote }),
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
