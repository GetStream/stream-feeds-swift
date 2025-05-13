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
    @State var showAddComment = false
    @State var activityName = ""
    @State var comment = ""
    @State var followSuggestions = [Feed]()
    
    init(credentials: UserCredentials) {
        let feedsClient = FeedsClient(
            apiKey: .init("892s22ypvt6m"),
            user: credentials.user,
            token: credentials.token
        )
        self.feedsClient = feedsClient
        let feed = feedsClient.flatFeed(group: "user", id: "martin1")
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
                            
                            HStack(spacing: 32) {
                                HStack {
                                    Button {
                                        showAddComment = true
                                    } label: {
                                        Image(systemName: "message")
                                    }
                                    
                                    Text("\(activity.commentCount)")
                                }
                                .alert("Add Comment", isPresented: $showAddComment) {
                                    TextField("Insert comment", text: $comment)
                                    Button("Cancel", role: .cancel) { }
                                    Button("Add") {
                                        Task {
                                            do {
                                                _ = try await feed.addComment(
                                                    activityId: activity.id,
                                                    request: .init(comment: comment)
                                                )
                                                comment = ""
                                            } catch {
                                                print("======= \(error)")
                                            }
                                        }
                                    }
                                }

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
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Divider()
                        }
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(followSuggestions) { feed in
                                FollowSuggestionView(owner: feed.owner)
                            }
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
                    let suggestionsResponse = try await self.feedsClient.getFollowSuggestions()
                    followSuggestions = suggestionsResponse.suggestions
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

extension Feed: Identifiable {}

struct FollowSuggestionView: View {
    
    let owner: UserResponse
    
    var body: some View {
        VStack {
            UserAvatar(url: owner.imageURL)
            Text(owner.name ?? owner.id)
        }
    }
}
