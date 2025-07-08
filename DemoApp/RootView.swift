//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct RootView: View {
    @AppStorage("userId") var userId: String = ""
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        Group {
            switch appState.viewState {
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
        .alert("Failed to Connect", isPresented: $appState.showsLoginAlert) {}
        .task {
            guard !userId.isEmpty, appState.client == nil else { return }
            await connect(with: UserCredentials.credentials(for: userId))
        }
    }
    
    private func connect(with credentials: UserCredentials) async {
        do {
            appState.viewState = .connecting
            let client = FeedsClient.client(for: credentials)
            try await client.connect()
            appState.client = client
            userId = credentials.id
            appState.viewState = .loggedIn(client)
        } catch {
            appState.viewState = .loggedOut
            appState.showsLoginAlert = true
        }
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

@MainActor class AppState: ObservableObject {
    
    static let shared = AppState()
    
    private init() {}
    
    @Published var pushToken: String? {
        didSet {
            if pushToken != oldValue {
                didUpdate(pushToken: pushToken)
            }
        }
    }
    @Published var viewState: ViewState = .loggedOut
    @Published var client: FeedsClient? {
        didSet {
            if client != nil {
                didUpdate(pushToken: pushToken)
            }

        }
    }
    @Published var showsLoginAlert = false
        
    private func didUpdate(pushToken: String?) {
        if let pushToken, let client {
            Task {
                do {
                    try await client.createDevice(id: pushToken)
                    log.debug("Push notification registration ✅")
                } catch {
                    log.error("Push notification registration ❌:\(error)")
                }
            }
        } else if let pushToken, !pushToken.isEmpty {
            log.debug("Deferring push notification setup for token:\(pushToken)")
        } else {
            log.debug("Clearing up push notification token.")
        }
    }
}

enum ViewState {
    case connecting
    case loggedIn(FeedsClient)
    case loggedOut
}

#Preview {
    RootView()
}
