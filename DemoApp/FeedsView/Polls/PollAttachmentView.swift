//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

public struct PollAttachmentView: View {
    private let colors = Colors.shared
        
    private let activity: ActivityData
    private let isFirst: Bool
    
    @StateObject var viewModel: PollAttachmentViewModel
    
    public init(
        feedsClient: FeedsClient,
        feed: Feed,
        activity: ActivityData,
        isFirst: Bool
    ) {
        self.activity = activity
        self.isFirst = isFirst
        _viewModel = StateObject(
            wrappedValue: PollAttachmentViewModel(
                feedsClient: feedsClient,
                feed: feed,
                poll: activity.poll!,
                activityInfo: activity
            )
        )
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(poll.name)
                        .font(.body)
                        .bold()
                    Spacer()
                }
                
                HStack {
                    Text(subtitleText)
                        .font(.caption)
                        .foregroundColor(Color(colors.textLowEmphasis))
                    Spacer()
                }
            }
            
            ForEach(options.prefix(PollAttachmentViewModel.numberOfVisibleOptionsShown)) { option in
                PollOptionView(
                    viewModel: viewModel,
                    option: option,
                    optionVotes: poll.voteCount(for: option),
                    maxVotes: poll.currentMaximumVoteCount,
                    textColor: .primary
                )
                .layoutPriority(1) // do not compress long text
            }
            
            if viewModel.showSuggestOptionButton {
                Button {
                    viewModel.suggestOptionShown = true
                } label: {
                    Text("Suggest an option")
                }
                .uiAlert(
                    title: "Suggest an option",
                    isPresented: $viewModel.suggestOptionShown,
                    text: $viewModel.suggestOptionText,
                    placeholder: "Add new option",
                    accept: "Add",
                    action: { viewModel.suggest(option: viewModel.suggestOptionText) }
                )
            }
            
            if viewModel.showAddCommentButton {
                Button {
                    viewModel.addCommentShown = true
                } label: {
                    Text("Add Comment")
                }
                .uiAlert(
                    title: "Add Comment",
                    isPresented: $viewModel.addCommentShown,
                    text: $viewModel.commentText,
                    accept: "Add",
                    action: { viewModel.add(comment: viewModel.commentText) }
                )
            }
            
            if viewModel.poll.answersCount > 0 {
                Button {
                    viewModel.allCommentsShown = true
                } label: {
                    Text("View all comments")
                }
                .fullScreenCover(isPresented: $viewModel.allCommentsShown) {
                    PollCommentsView(
                        pollId: poll.id,
                        activity: viewModel.activity,
                        user: viewModel.feedsClient.user,
                        client: viewModel.feedsClient
                    )
                }
            }
            
            Button {
                viewModel.pollResultsShown = true
            } label: {
                Text("View results")
            }
            .fullScreenCover(isPresented: $viewModel.pollResultsShown) {
                PollResultsView(viewModel: viewModel)
            }
            
            if viewModel.showEndVoteButton {
                Button {
                    viewModel.endVoteConfirmationShown = true
                } label: {
                    Text("End vote")
                }
                .actionSheet(isPresented: $viewModel.endVoteConfirmationShown) {
                    ActionSheet(
                        title: Text("End poll"),
                        buttons: [
                            .destructive(Text("End")) {
                                viewModel.endVote()
                            },
                            .cancel(Text("Cancel"))
                        ]
                    )
                }
            }
        }
        .disabled(!viewModel.canInteract)
        .padding()
        .background(Color(colors.background1))
        .cornerRadius(16)
        .padding()
    }
    
    private var poll: PollData {
        viewModel.poll
    }
    
    private var options: [PollOptionData] {
        poll.options
    }
    
    private var subtitleText: String {
        if poll.isClosed == true {
            return "Vote Ended"
        } else if poll.enforceUniqueVote == true {
            return "Select one"
        } else {
            return "Select one or more"
        }
    }
}

struct PollOptionView: View {
    @ObservedObject var viewModel: PollAttachmentViewModel
    
    let option: PollOptionData
    var optionFont: Font = .body
    var optionVotes: Int?
    var maxVotes: Int?
    var textColor: Color
    /// If true, only option name and vote count is shown, otherwise votes indicator and avatars appear as well.
    var alternativeStyle: Bool = false
    /// The spacing between the checkbox and the option name.
    /// By default it is 4. For All Options View is 8.
    var checkboxButtonSpacing: CGFloat = 4

    var body: some View {
        HStack(alignment: .top, spacing: checkboxButtonSpacing) {
            if viewModel.poll.isClosed != true {
                Button {
                    togglePollVote()
                } label: {
                    if viewModel.optionVotedByCurrentUser(option) {
                        Image(systemName: "checkmark.circle.fill")
                    } else {
                        Image(systemName: "circle")
                    }
                }
            }
            VStack(spacing: 4) {
                HStack(alignment: .top) {
                    Text(option.text)
                        .font(optionFont)
                        .foregroundColor(textColor)
                    Spacer()
//                    if !alternativeStyle, viewModel.showVoterAvatars {
//                        HStack(spacing: -4) {
//                            ForEach(
//                                option.latestVotes.prefix(2)
//                            ) { vote in
//                                UserAvatar(url: vote.user?.imageURL, size: 20)
//                            }
//                        }
//                    }
                    Text("\(viewModel.poll.voteCountsByOption[option.id] ?? 0)")
                        .foregroundColor(textColor)
                }
                if !alternativeStyle {
                    PollVotesIndicatorView(
                        alternativeStyle: viewModel.poll.isClosed == true && viewModel.hasMostVotes(for: option),
                        optionVotes: optionVotes ?? 0,
                        maxVotes: maxVotes ?? 0
                    )
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            togglePollVote()
        }
    }

    func togglePollVote() {
        if viewModel.optionVotedByCurrentUser(option) {
            viewModel.deletePollVote(for: option)
        } else {
            viewModel.castPollVote(for: option)
        }
    }
}

struct PollVotesIndicatorView: View {
    let colors = Colors.shared
    
    let alternativeStyle: Bool
    let optionVotes: Int
    let maxVotes: Int
    
    private let height: CGFloat = 4
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(colors.background2))
                    .frame(width: reader.size.width, height: height)

                RoundedRectangle(cornerRadius: 8)
                    .fill(alternativeStyle ? Color(colors.alternativeActiveTint) : colors.tintColor)
                    .frame(width: reader.size.width * ratio, height: height)
            }
        }
        .frame(height: height)
    }
    
    var ratio: CGFloat {
        CGFloat(optionVotes) / CGFloat(max(maxVotes, 1))
    }
}
