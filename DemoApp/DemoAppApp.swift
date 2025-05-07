//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 24.4.25.
//

import SwiftUI
import StreamCore
import StreamFeeds

@main
struct DemoAppApp: App {
    
    @State var feedsClient: FeedsClient
    @State var feed: FlatFeed
    @ObservedObject var state: FeedState
    
    @State var showAddActivity = false
    @State var activityName = ""
    
    init() {
        let feedsClient = FeedsClient(
            apiKey: .init("892s22ypvt6m"),
            user: .init(id: "martin"),
            token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFydGluIn0.-8mL49OqMdlvzXR_1IgYboVXXuXFc04r0EvYgko-X8I")
        )
        self.feedsClient = feedsClient
        let feed = feedsClient.flatFeed(group: "user", id: "martin")
        self.feed = feed
        state = feed.state
        LogConfig.level = .debug
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(state.activities) { activity in
                            HStack {
                                Text(activity.text)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text("Stream Feeds")
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddActivity = true
                        } label: {
                            Text("Add activity")
                        }
                    }
                })
            }
            .onAppear {
                Task {
                    do {
                        let response = try await self.feed.get()
                    } catch {
                        print("====== \(error)")
                    }
                }
            }
            .alert("Add activity", isPresented: $showAddActivity) {
                TextField("Activity name", text: $activityName)
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    Task {
                        do {
                            _ = try await feed.addActivity(text: activityName)
                            activityName = ""
                        } catch {
                            print("======= \(error)")
                        }
                    }
                }
            }
        }
    }
}
