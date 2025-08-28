//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct DebugFeedView: View {
    @Environment(\.dismiss) var dismiss
    @State private var lastError: Error?
    
    let feed: Feed
    let client: FeedsClient
    
    var body: some View {
        NavigationView {
            List {
                Section("Feed") {
                    ForEach(feedActions) { item in
                        AsyncButton {
                            await invokeAction(item)
                        } label: {
                            Text(item.title)
                        }
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
    
    private func invokeAction(_ action: DebugAction) async {
        do {
            try await action.action()
            dismiss()
        } catch {
            lastError = error
        }
    }
    
    var feedActions: [DebugAction] {
        [
            DebugAction(title: "Generate 10 Activities") {
                for index in (0..<10).reversed() {
                    let request = FeedAddActivityRequest(
                        text: "Generated \(index) at \(Date().formatted(.dateTime))",
                        type: "activity"
                    )
                    try await feed.addActivity(request: request)
                    try await Task.sleep(nanoseconds: 500_000_000)
                }
            }
        ]
    }
}

struct DebugAction: Identifiable {
    let title: String
    let action: () async throws -> Void
    
    var id: String { title }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable var client = FeedsClient.client(for: .toomas)
    DebugFeedView(
        feed: client.feed(
            for: FeedQuery(
                feed: FeedId(group: "user", id: UserCredentials.toomas.id),
                data: nil
            )
        ),
        client: client
    )
}
