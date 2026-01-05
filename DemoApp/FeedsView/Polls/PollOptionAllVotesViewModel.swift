//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import StreamFeeds
import SwiftUI

@MainActor class PollOptionAllVotesViewModel: ObservableObject {
    let poll: PollData
    let option: PollOptionData
    let activity: Activity
    let feedsClient: FeedsClient
    
    @Published private(set) var pollVotes = [PollVoteData]()
    @Published var bannerError: Error?
    @Published private(set) var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var animateChanges = false
    private let voteList: PollVoteList
        
    init(poll: PollData, option: PollOptionData, activity: Activity, feedsClient: FeedsClient) {
        self.poll = poll
        self.option = option
        self.activity = activity
        self.feedsClient = feedsClient
        voteList = feedsClient.pollVoteList(
            for: .init(
                pollId: poll.id,
                userId: feedsClient.user.id,
                filter: .equal(.optionId, option.id)
            )
        )
        voteList.state.$votes
            .assign(to: \.pollVotes, onWeak: self)
            .store(in: &cancellables)
        // No animation for initial load
        $pollVotes
            .dropFirst()
            .map { _ in true }
            .assign(to: \.animateChanges, onWeak: self)
            .store(in: &cancellables)
    }
    
    func refresh() async {
        defer { isLoading = false }
        isLoading = true
        do {
            try await voteList.get()
        } catch {
            bannerError = error
        }
    }
    
    func loadMoreVotes() async {
        guard voteList.state.canLoadMore else { return }
        do {
            try await voteList.queryMorePollVotes()
        } catch {
            bannerError = error
        }
    }
}
