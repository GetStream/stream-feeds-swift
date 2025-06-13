//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct RootView: View {
    @AppStorage("userId") var userId: String = ""
    @State private var state: ViewState = .loggedOut
    @State private var client: FeedsClient?
    @State private var showsLoginAlert = false
    
    var body: some View {
        Group {
            switch state {
            case .connecting:
                ProgressView()
            case .loggedIn(let feedsClient):
                FeedsView(client: feedsClient)
            case .loggedOut:
                LoginView { userCredentials in
                    Task { await connect(with: userCredentials) }
                }
            }
        }
        .alert("Failed to Connect", isPresented: $showsLoginAlert) {}
        .task {
            guard !userId.isEmpty, client == nil else { return }
            await connect(with: UserCredentials.credentials(for: userId))
        }
    }
    
    private func connect(with credentials: UserCredentials) async {
        do {
            state = .connecting
            let client = FeedsClient.client(for: credentials)
            try await client.connect()
            userId = credentials.id
            state = .loggedIn(client)
        } catch {
            state = .loggedOut
            showsLoginAlert = true
        }
    }
}

extension RootView {
    enum ViewState {
        case connecting
        case loggedIn(FeedsClient)
        case loggedOut
    }
}

extension FeedsClient {
    static func client(for credentials: UserCredentials) -> FeedsClient {
        LogConfig.level = .debug
        return FeedsClient(
            apiKey: .init("892s22ypvt6m"),
            user: credentials.user,
            token: credentials.token
        )
    }
}

#Preview {
    RootView()
}
