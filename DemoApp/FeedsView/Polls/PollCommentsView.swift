//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct PollCommentsView: View {
    let colors = Colors.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: PollCommentsViewModel
    
    init(
        pollId: String,
        activity: Activity,
        user: User,
        client: FeedsClient,
        viewModel: PollCommentsViewModel? = nil
    ) {
        _viewModel = StateObject(
            wrappedValue: viewModel ?? PollCommentsViewModel(
                pollId: pollId,
                activity: activity,
                user: user,
                client: client
            )
        )
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.comments) { comment in
                        if let answer = comment.answerText {
                            VStack(alignment: .leading) {
                                Text(answer)
                                    .bold()
                                HStack {
                                    if viewModel.poll?.votingVisibility != "anonymous" {
                                        UserAvatar(url: comment.user?.imageURL)
                                    }
                                    Text(authorTitle(for: comment))
                                    Spacer()
                                    PollDateIndicatorView(date: comment.createdAt)
                                }
                            }
                            .withPollsBackground()
                        }
                    }
                    if viewModel.showsAddCommentButton {
                        Button(action: {
                            viewModel.addCommentShown = true
                        }, label: {
                            Text(commentButtonTitle)
                                .bold()
                                .foregroundColor(colors.tintColor)
                        })
                        .frame(maxWidth: .infinity)
                        .withPollsBackground()
                        .uiAlert(
                            title: commentButtonTitle,
                            isPresented: $viewModel.addCommentShown,
                            text: $viewModel.newCommentText,
                            accept: "Add",
                            action: { viewModel.add(comment: viewModel.newCommentText) }
                        )
                    }
                }
                .loadingContent(isLoading: viewModel.isLoading)
                .errorBanner(for: $viewModel.bannerError)
                .onScrollPaginationChanged(onBottomThreshold: {
                    await viewModel.loadMoreVotes()
                })
                .padding()
            }
            .task {
                await viewModel.refresh()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Comments")
                        .bold()
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var commentButtonTitle: String {
        viewModel.currentUserAddedComment
            ? "Update comment"
            : "Add comment"
    }
    
    private func authorTitle(for comment: PollVoteData) -> String {
        if viewModel.poll?.votingVisibility == "anonymous" {
            return "anonymous"
        }
        return comment.user?.name ?? "anonymous"
    }
}
