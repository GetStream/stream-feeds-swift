//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct PollResultsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: PollAttachmentViewModel
    
    let colors = Colors.shared
    
    private let numberOfItemsShown = 5
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
        }
    }
    
    var content: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                HStack {
                    Text(viewModel.poll.name)
                        .bold()
                    Spacer()
                }
                .withPollsBackground()
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                ForEach(viewModel.poll.options) { option in
                    PollOptionResultsView(
                        poll: viewModel.poll,
                        option: option,
                        votes: Array(
                            []
                            //TODO: we should expose this?
//                            option.latestVotes
//                                .prefix(numberOfItemsShown)
                        ),
                        allButtonShown: true, //TODO: option.latestVotes.count > numberOfItemsShown,
                        hasMostVotes: viewModel.hasMostVotes(for: option),
                        activity: viewModel.activity,
                        feedsClient: viewModel.feedsClient
                    )
                }
                Spacer()
            }
        }
        .background(Color(colors.background).ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Results")
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

struct PollOptionResultsView: View {
    
    let colors = Colors.shared
    
    var poll: PollData
    var option: PollOptionData
    var votes: [PollVoteData]
    var allButtonShown = false
    var hasMostVotes: Bool = false
    var activity: Activity
    var feedsClient: FeedsClient
    var onVoteAppear: ((PollVoteData) -> Void)?
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text(option.text)
                    .font(.body)
                Spacer()
                if hasMostVotes {
                    Image(systemName: "trophy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                }
                Text("\(poll.voteCountsByOption[option.id] ?? 0)")
            }
            
            ForEach(votes, id: \.displayId) { vote in
                HStack {
                    if poll.votingVisibility != "anonymous" {
                        UserAvatar(url: vote.user?.imageURL, size: 20)
                    }
                    Text(vote.user?.name ?? (vote.user?.id ?? "anonymous"))
                    Spacer()
                    PollDateIndicatorView(date: vote.createdAt)
                }
                .onAppear {
                    onVoteAppear?(vote)
                }
            }
            
            if allButtonShown {
                NavigationLink {
                    PollOptionAllVotesView(poll: poll, option: option, activity: activity, feedsClient: feedsClient)
                } label: {
                    Text("Show all")
                }
            }
        }
        .withPollsBackground()
        .padding(.horizontal)
    }
}

extension PollVoteData {
    var displayId: String {
        "\(id)-\(optionId)-\(pollId)"
    }
}
