//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct FeedsView: View {
    let client: FeedsClient
    @State private var feed: Feed
    @State private var presentedSheet: Sheet?
    @State private var showsLogoutAlert = false
    @ObservedObject var appState = AppState.shared
    @AppStorage("userId") var userId: String = ""
    
    init(client: FeedsClient) {
        self.client = client
        let query = FeedQuery(
            fid: FeedId(group: "user", id: client.user.id),
            data: .init(
                members: [.init(userId: client.user.id)],
                visibility: .public
            )
        )
        _feed = State(initialValue: client.feed(for: query))
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
                    Button {
                        showsLogoutAlert = true
                    } label: {
                        UserAvatar(url: client.user.imageURL)
                    }
                }
            })
        }
        .sheet(item: $presentedSheet, content: { makeSheet($0) })
        .alert("Logout", isPresented: $showsLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("OK") {
                logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
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
    
    private func logout() {
        Task {
            // Disconnect the client
            await client.disconnect()
            
            // Clear the client
            appState.client = nil
            
            // Clear user defaults
            userId = ""
            
            // Update view state to logged out
            appState.viewState = .loggedOut
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
