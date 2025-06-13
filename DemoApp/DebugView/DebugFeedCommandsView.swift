//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct DebugFeedCommandsView: View {
    @State private var lastError: Error?
    
    let feedId: String
    let feedsClient: FeedsClient
    
    var body: some View {
        NavigationView {
            List {
                Section("Feed") {
                    ForEach(feedActions) { item in
                        Button(action: { invokeAction(item) }, label: { Text(item.title) })
                    }
                }
            }
            .alert("Debug command failed", isPresented: showsAlert, actions: {}, message: { Text(lastError?.localizedDescription ?? "") })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Debug Commands")
        }
    }
    
    var showsAlert: Binding<Bool> {
        Binding(get: { lastError != nil }, set: { flag in lastError = flag ? lastError : nil })
    }
    
    private func invokeAction(_ action: DebugAction) {
        Task {
            do {
                try await action.action()
            } catch {
                lastError = error
            }
        }
    }
    
    var feedActions: [DebugAction] {
        [
            DebugAction(title: "Generate Activities") {
                // TODO: Fill in
            }
        ]
    }
}

struct DebugAction: Identifiable {
    let title: String
    let action: () async throws -> Void
    
    var id: String { title }
}

#Preview {
    DebugFeedCommandsView(feedId: "1", feedsClient: .client(for: .toomas))
}
