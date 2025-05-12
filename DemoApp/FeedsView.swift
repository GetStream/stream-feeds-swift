//
//  FeedsView.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 9.5.25.
//

import SwiftUI
import StreamCore
import StreamFeeds

struct FeedsView: View {
    
    @State var feedsClient: FeedsClient
    @State var feed: FlatFeed
    @ObservedObject var state: FeedState
    
    @State var showAddActivity = false
    @State var activityName = ""
    
    init(credentials: UserCredentials) {
        let feedsClient = FeedsClient(
            apiKey: .init("892s22ypvt6m"),
            user: credentials.user,
            token: credentials.token
        )
        self.feedsClient = feedsClient
        let feed = feedsClient.flatFeed(group: "user", id: "martin")
        self.feed = feed
        state = feed.state
        LogConfig.level = .debug
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(state.activities) { activity in
                        VStack {
                            HStack {
                                UserAvatar(url: activity.user.imageURL)
                                VStack(alignment: .leading) {
                                    Text(activity.user.name ?? activity.user.id)
                                        .font(.caption)
                                        .bold()
                                    Text(activity.text)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            
                            HStack {
                                Button {
                                    Task {
                                        do {
                                            if activity.ownReactions == nil {
                                                try await feed.addReaction(activityId: activity.id, request: .init(type: "heart"))
                                            } else {
                                                try await feed.removeReaction(activityId: activity.id)
                                            }
                                        } catch {
                                            print("===== \(error)")
                                        }
                                    }
                                } label: {
                                    Image(systemName: activity.ownReactions != nil ? "heart.fill" : "heart")
                                }
                                
                                Text("\(activity.reactionCount)")
                            }
                            
                            Divider()
                        }
                    }
                }
            }
            .padding(.top)
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
                
                ToolbarItem(placement: .topBarLeading) {
                    UserAvatar(url: feedsClient.user.imageURL)
                }
            })
        }
        .onAppear {
            Task {
                do {
                    let response = try await self.feed.getOrCreate(watch: true)
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

struct UserAvatar: View {
    
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 36, height: 36)
        .clipShape(Circle())
    }
}

extension UserResponse {
    var imageURL: URL? {
        if let image {
            return URL(string: image)
        } else {
            return nil
        }
    }
}

extension Activity {
    var reactionCount: Int {
        reactionGroups?.values.compactMap(\.count).reduce(0, +) ?? 0
    }
}
