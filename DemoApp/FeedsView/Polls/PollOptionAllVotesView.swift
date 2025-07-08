//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct PollOptionAllVotesView: View {
    @StateObject var viewModel: PollOptionAllVotesViewModel
    
    init(
        poll: PollData,
        option: PollOptionData,
        activity: Activity,
        feedsClient: FeedsClient
    ) {
        _viewModel = StateObject(
            wrappedValue: PollOptionAllVotesViewModel(
                poll: poll,
                option: option,
                activity: activity,
                feedsClient: feedsClient
            )
        )
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                PollOptionResultsView(
                    poll: viewModel.poll,
                    option: viewModel.option,
                    votes: viewModel.pollVotes,
                    activity: viewModel.activity,
                    feedsClient: viewModel.feedsClient
                )
            }
            .loadingContent(isLoading: viewModel.isLoading)
            .errorBanner(for: $viewModel.bannerError)
            .onScrollPaginationChanged(onBottomThreshold: {
                await viewModel.loadMoreVotes()
            })
        }
        .onLoad {
            await viewModel.refresh()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.option.text)
                    .bold()
            }
        }
    }
}
