//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct FeedsView: View {
    let client: FeedsClient
    @State private var feed: Feed
    @State private var profileShown = false
    
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
                        profileShown = true
                    } label: {
                        Image(systemName: "person")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    UserAvatar(url: client.user.imageURL)
                }
            })
        }
        .sheet(isPresented: $profileShown) {
            ProfileView(feed: feed, feedsClient: client)
        }
    }
}

#Preview {
    FeedsView(client: .client(for: .toomas))
}
