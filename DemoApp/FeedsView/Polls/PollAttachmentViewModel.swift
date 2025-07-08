//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import StreamFeeds
import SwiftUI

/// View model for the `PollAttachmentView`.
@MainActor public class PollAttachmentViewModel: ObservableObject {
    static let numberOfVisibleOptionsShown = 10
    private var isCastingVote = false
    @Published private var isClosingPoll = false
        
    let feedsClient: FeedsClient
    let feed: Feed
    let activityInfo: ActivityData
    
    private var _activity: Activity?
    
    private var cancellables = Set<AnyCancellable>()
    
    var activity: Activity {
        if let _activity {
            return _activity
        }
        let activity = feedsClient.activity(for: activityInfo.id, in: feed.fid)
        _activity = activity
        return activity
    }
    
    /// The object representing the state of the poll.
    @Published public var poll: PollData
    
    /// If true, an alert with a text field is shown allowing to suggest new options.
    @Published public var suggestOptionShown = false
    
    /// If true, an alert with a text field is shown allowing to send a comment.
    @Published public var addCommentShown = false
    
    /// Suggested option title written by an user using an alert.
    @Published public var suggestOptionText = ""
    
    /// Comment text written by an user using an alert.
    @Published public var commentText = ""
    
    /// If true, a sheet is shown revealing poll results.
    @Published public var pollResultsShown = false {
        didSet {
            notifySheetPresentation(shown: pollResultsShown)
        }
    }
    
    /// It true, a sheet is shown with all the poll comments.
    @Published public var allCommentsShown = false {
        didSet {
            notifySheetPresentation(shown: allCommentsShown)
        }
    }
    
    /// If true, a sheet is shown with all the poll options.
    ///
    /// Used for polls with more than 10 options.
    @Published public var allOptionsShown = false {
        didSet {
            notifySheetPresentation(shown: allOptionsShown)
        }
    }
    
    /// A list of votes given by the current user.
    @Published public var currentUserVotes = [PollVoteData]()
    
    private let createdByCurrentUser: Bool
        
    /// If true, an action sheet is shown for closing the poll, otherwise hidden.
    @Published public var endVoteConfirmationShown = false
    
    @available(*, deprecated, message: "Replaced with inline alert banners displayed by the showChannelAlertBannerNotification")
    @Published public var errorShown = false

    /// If true, poll controls are in enabled state, otherwise disabled.
    public var canInteract: Bool {
        guard !isClosingPoll else { return false }
        guard !endVoteConfirmationShown else { return false }
        return true
    }
    
    /// If true, end vote button is visible under votes, otherwise hidden.
    public var showEndVoteButton: Bool {
        poll.isClosed != true && createdByCurrentUser
    }
    
    /// If true, suggest new option button is visible under votes allowing users to add more poll options, otherwise hidden.
    public var showSuggestOptionButton: Bool {
        poll.isClosed != true && poll.allowUserSuggestedOptions == true
    }
    
    /// If true, add comment button is visible under votes, otherwise hidden.
    public var showAddCommentButton: Bool {
        let addCommentAvailable = poll.isClosed != true && poll.allowAnswers
        if poll.votingVisibility == "anonymous" {
            return addCommentAvailable
        }
        return addCommentAvailable
            && (
                poll.latestAnswers.filter {
                    $0.user?.id == feedsClient.user.id && $0.isAnswer == true
                }
            )
            .isEmpty
    }
    
    /// If true, user avatars who have voted should be shown with the option, otherwise hidden.
    ///
    /// The default is to hide avatars when the poll is anonymous.
    public var showVoterAvatars: Bool {
        poll.votingVisibility != "anonymous"
    }
    
    public init(feedsClient: FeedsClient, feed: Feed, poll: PollData, activityInfo: ActivityData) {
        self.feedsClient = feedsClient
        self.feed = feed
        self.poll = poll
        self.activityInfo = activityInfo
        createdByCurrentUser = poll.createdBy?.id == feedsClient.user.id
        currentUserVotes = poll.ownVotes
        Task { @MainActor in
            activity.state.$poll.sink { [weak self] poll in
                if let poll {
                    self?.poll = poll
                }
            }
            .store(in: &cancellables)
        }
    }
        
    /// Casts a vote for a poll.
    ///
    /// - Parameter option: The option user tapped on.
    public func castPollVote(for option: PollOptionData) {
        guard !isCastingVote else { return }
        isCastingVote = true
        Task {
            do {
                try await activity.castPollVote(
                    request: .init(vote: .init(optionId: option.id))
                )
                try await Task.sleep(nanoseconds: 300_000_000)
                self.isCastingVote = false
            } catch {
                log.error("Error casting poll vote \(error)")
                try await Task.sleep(nanoseconds: 300_000_000)
                self.isCastingVote = false
            }
        }
    }
    
    /// Adds a comment to the poll.
    ///
    /// Each poll participant can add a single comment. If a comment exists from the current user, the comment is editted.
    ///
    /// - Parameter comment: A comment added to the poll.
    public func add(comment: String) {
        Task {
            try await activity.castPollVote(
                request: .init(vote: .init(answerText: comment))
            )
        }
        commentText = ""
    }
    
    /// Removes the given vote from the specified option.
    /// - Parameter option: The option user tapped on.
    public func deletePollVote(for option: PollOptionData) {
        guard !isCastingVote else { return }
        isCastingVote = true
        guard let vote = currentUserVote(for: option) else { return }
        Task {
            do {
                try await activity.deletePollVote(
                    voteId: vote.id,
                    userId: feedsClient.user.id
                )
                self.isCastingVote = false
            } catch {
                self.isCastingVote = false
            }
        }
    }
    
    /// Closes the poll.
    ///
    /// Closed poll can't be updated in any way.
    public func endVote() {
        guard !isClosingPoll else { return }
        isClosingPoll = true
        Task {
            do {
                try await activity.closePoll()
                self.isClosingPoll = false
            } catch {
                self.isClosingPoll = false
            }
        }
    }
    
    /// True, if the current user has voted for the specified option, otherwise false.
    public func optionVotedByCurrentUser(_ option: PollOptionData) -> Bool {
        poll.hasCurrentUserVoted(for: option)
    }
    
    /// Adds a new option to the poll.
    /// - Parameter option: The suggested option.
    public func suggest(option: String) {
        suggestOptionText = ""
        let isDuplicate = poll.options.contains(where: { $0.text.trimmed.caseInsensitiveCompare(option.trimmed) == .orderedSame })
        guard !isDuplicate else { return }
        Task {
            try await activity.createPollOption(
                request: .init(text: suggestOptionText)
            )
        }
    }
    
    /// Returns true if the specified option has more votes than any other option.
    ///
    /// - Note: When multiple options have the highest vote count, this function returns false.
    public func hasMostVotes(for option: PollOptionData) -> Bool {
        poll.isOptionWithMostVotes(option)
    }
    
    // MARK: - private
    
    private func currentUserVote(for option: PollOptionData) -> PollVoteData? {
        poll.currentUserVote(for: option)
    }
    
    private func notifySheetPresentation(shown: Bool) {
        let name: Notification.Name = shown ? .messageSheetShownNotification : .messageSheetHiddenNotification
        NotificationCenter.default.post(
            name: name,
            object: nil
        )
    }
}

public extension PollData {
    /// The value of the option with the most votes.
    var currentMaximumVoteCount: Int {
        voteCountsByOption.values.max() ?? 0
    }

    /// Whether the poll is already closed and the provided option is the one, and **the only one** with the most votes.
    func isOptionWinner(_ option: PollOptionData) -> Bool {
        isClosed == true && isOptionWithMostVotes(option)
    }

    /// Whether the poll is already close and the provided option is one of that has the most votes.
    func isOptionOneOfTheWinners(_ option: PollOptionData) -> Bool {
        isClosed == true && isOptionWithMaximumVotes(option)
    }

    /// Whether the provided option is the one, and **the only one** with the most votes.
    func isOptionWithMostVotes(_ option: PollOptionData) -> Bool {
        let optionsWithMostVotes = voteCountsByOption.filter { $0.value == currentMaximumVoteCount }
        return optionsWithMostVotes.count == 1 && optionsWithMostVotes[option.id] != nil
    }

    /// Whether the provided option is one of that has the most votes.
    func isOptionWithMaximumVotes(_ option: PollOptionData) -> Bool {
        let optionsWithMostVotes = voteCountsByOption.filter { $0.value == currentMaximumVoteCount }
        return optionsWithMostVotes[option.id] != nil
    }

    /// The vote count for the given option.
    func voteCount(for option: PollOptionData) -> Int {
        voteCountsByOption[option.id] ?? 0
    }
    
    // The ratio of the votes for the given option in comparison with the number of total votes.
    func voteRatio(for option: PollOptionData) -> Float {
        if currentMaximumVoteCount == 0 {
            return 0
        }

        let optionVoteCount = voteCount(for: option)
        return Float(optionVoteCount) / Float(currentMaximumVoteCount)
    }

    /// Returns the vote of the current user for the given option in case the user has voted.
    func currentUserVote(for option: PollOptionData) -> PollVoteData? {
        ownVotes.first(where: { $0.optionId == option.id })
    }

    /// Returns a Boolean value indicating whether the current user has voted the given option.
    func hasCurrentUserVoted(for option: PollOptionData) -> Bool {
        ownVotes.contains(where: { $0.optionId == option.id })
    }
}

extension Notification.Name {
    /// A notification for notifying when an error occured and an alert banner should be shown at the top of the message list.
    static let showChannelAlertBannerNotification = Notification.Name("showChannelAlertBannerNotification")
    
    /// A notification for notifying when message dismissed a sheet.
    static let messageSheetHiddenNotification = Notification.Name("messageSheetHiddenNotification")
    
    /// A notification for notifying when message view displays a sheet.
    ///
    /// When a sheet is presented, the message cell is not reloaded.
    static let messageSheetShownNotification = Notification.Name("messageSheetShownNotification")
}
