//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import StreamFeeds
import SwiftUI

class PollCommentsViewModel: ObservableObject {
    
    @Published var comments = [PollVoteResponseData]()
    @Published var newCommentText = ""
    @Published var addCommentShown = false
    @Published var errorShown = false
    
    let poll: PollResponseData
    let activity: Activity
    let user: User
        
    private var cancellables = Set<AnyCancellable>()
    private(set) var animateChanges = false
    private var loadingComments = true
        
    init(poll: PollResponseData, activity: Activity, user: User) {
        self.poll = poll
        self.activity = activity
        self.user = user
        refresh()
        
        // No animation for initial load
        $comments
            .dropFirst()
            .map { _ in true }
            .assignWeakly(to: \.animateChanges, on: self)
            .store(in: &cancellables)

    }
    
    func refresh() {
        loadingComments = true
        Task {
            do {
                try await activity.queryPollVotes(
                    pollId: poll.id,
                    userId: user.id,
                    queryPollVotesRequest: .init(filter: ["is_answer": .bool(true)])
                )
                loadingComments = false
            } catch {
                loadingComments = false
                self.errorShown = true
            }
        }
    }
    
    var showsAddCommentButton: Bool {
        poll.isClosed == false
    }
    
    var currentUserAddedComment: Bool {
        !comments.filter { $0.user?.id == user.id }.isEmpty
    }
    
    func add(comment: String) {
        Task { @MainActor in
            try await activity.castPollVote(
                activityId: activity.activityId,
                pollId: poll.id,
                castPollVoteRequest: .init(vote: .init(answerText: newCommentText))
            )
        }
        newCommentText = ""
    }
    
    func onAppear(comment: PollVoteResponseData) {
        guard !loadingComments,
              let index = comments.firstIndex(where: { $0 == comment }),
              index > comments.count - 10 else { return }
        
        loadComments()
    }
    
    //TODO: pagination
    private func loadComments() {
//        guard !loadingComments, !commentsController.hasLoadedAllVotes else { return }
//        loadingComments = true
//        commentsController.loadMoreVotes { [weak self] error in
//            self?.loadingComments = false
//            if error != nil {
//                self?.errorShown = true
//            }
//        }
    }
}
