//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import StreamFeeds
import SwiftUI

@MainActor class PollCommentsViewModel: ObservableObject {
    @Published var comments = [PollVoteData]()
    @Published var newCommentText = ""
    @Published var addCommentShown = false
    @Published var bannerError: Error?
    @Published private(set) var isLoading = false
    
    let activity: Activity
    let user: User
        
    private var cancellables = Set<AnyCancellable>()
    private(set) var animateChanges = false
    private let voteList: PollVoteList
    
    @Published private(set) var poll: PollData?
        
    init(pollId: String, activity: Activity, user: User, client: FeedsClient) {
        self.activity = activity
        self.user = user
        voteList = client.pollVoteList(
            for: .init(
                pollId: pollId,
                userId: user.id,
                filter: .equal(.isAnswer, true)
            )
        )
        voteList.state.$votes
            .assign(to: \.comments, onWeak: self)
            .store(in: &cancellables)
        activity.state.$poll
            .assign(to: \.poll, onWeak: self)
            .store(in: &cancellables)
        // No animation for initial load
        $comments
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
    
    var showsAddCommentButton: Bool {
        activity.state.poll?.isClosed == false
    }
    
    var currentUserAddedComment: Bool {
        !comments.filter { $0.user?.id == user.id }.isEmpty
    }
    
    func add(comment: String) {
        Task { @MainActor in
            try await activity.castPollVote(
                request: .init(vote: .init(answerText: newCommentText))
            )
            newCommentText = ""
        }
    }
}
