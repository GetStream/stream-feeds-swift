//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct FeedsView: View {
    let client: FeedsClient
    @State private var feed: Feed
    @State private var presentedSheet: Sheet?
    
    init(client: FeedsClient) {
        self.client = client
        let feed = client.feed(group: "user", id: client.user.id)
        _feed = State(initialValue: feed)
    }
    
    var body: some View {
        NavigationView {
            FeedsListView(
                feed: feed,
                client: client
            )
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("Stream Feeds")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentedSheet = .feedDebugCommands
                    } label: {
                        Image(systemName: "hammer")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentedSheet = .profile
                    } label: {
                        Image(systemName: "person")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    UserAvatar(url: client.user.imageURL)
                }
            })
        }
        .sheet(item: $presentedSheet, content: makeSheet)
    }
    
    @ViewBuilder
    private func makeSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .feedDebugCommands:
            DebugFeedView(feed: feed, client: client)
        case .profile:
            ProfileView(feed: feed, client: client)
        }
    }
}

extension FeedsView {
    enum Sheet: String, Identifiable {
        case feedDebugCommands
        case profile
        var id: String { rawValue }
    }
}

#Preview {
    FeedsView(client: .client(for: .toomas))
}
