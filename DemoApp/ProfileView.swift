//
//  ProfileView.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 19.5.25.
//

import SwiftUI
import StreamCore
import StreamFeeds

struct ProfileView: View {
    
    @AppStorage("userId") var userId: String = ""
    
    let feed: Feed
    let feedsClient: FeedsClient
    @ObservedObject var state: FeedState
    
    @State var followSuggestions = [FeedResponse]()
    
    init(feed: Feed, feedsClient: FeedsClient) {
        self.feed = feed
        self.feedsClient = feedsClient
        self.state = feed.state
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Follow Requests")
                        .font(.headline)
                    VStack {
                        ForEach(feed.state.followRequests) { request in
                            HStack {
                                Text(request.sourceFeed.createdBy.name ?? request.sourceFeed.createdBy.id)
                                Spacer()
                                Button {
                                    Task {
                                        try await feed.acceptFollow(
                                            request: .init(sourceFid: request.sourceFid, targetFid: request.targetFid)
                                        )
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                                
                                Button {
                                    Task {
                                        try await feed.rejectFollow(
                                            request: .init(sourceFid: request.sourceFid, targetFid: request.targetFid)
                                        )
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Text("Following")
                        .font(.headline)
                    ForEach(state.following) { follow in
                        HStack {
                            Text(follow.targetFeed.createdBy.name ?? follow.targetFeed.createdBy.id)
                            Spacer()
                            Button {
                                Task {
                                    try await feed.unfollow(targetFid: follow.targetFid)
                                }
                            } label: {
                                Text("Unfollow")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if state.following.isEmpty {
                        Text("You are not following anyone")
                    }
                    Divider()
                    Text("Followers")
                        .font(.headline)
                    ForEach(state.followers) { follow in
                        HStack {
                            Text(follow.sourceFeed.createdBy.name ?? follow.sourceFeed.createdBy.id)
                            Spacer()
                            Button {
                                Task {
                                    try await feed.unfollow(sourceFid: follow.sourceFid, targetFid: follow.targetFid)
                                }
                            } label: {
                                Text("Remove Follower")
                            }
                        }
                        .padding(.horizontal)
                    }
                    if state.followers.isEmpty {
                        Text("You don't have any followers.")
                    }
                    
                    Divider()
                    
                    Text("Who to follow")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        HStack(spacing: 24) {
                            ForEach(followSuggestions) { suggestion in
                                FollowSuggestionView(
                                    owner: suggestion.createdBy,
                                    feed: feed,
                                    targetFeed: suggestion
                                )
                            }
                        }
                    }
                    
                    Divider()
                }
                .padding()
            }
            .navigationTitle("Profile")
            .onAppear {
                Task {
                    let suggestionsResponse = try await self.feedsClient.getFollowSuggestions(
                        feedGroupId: "user", limit: 10
                    )
                    followSuggestions = suggestionsResponse.suggestions
                }
            }
        }
    }
}

extension FollowResponse: Identifiable {}

struct FollowSuggestionView: View {
    
    let owner: UserResponse
    let feed: Feed
    let targetFeed: FeedResponse
    
    var body: some View {
        VStack {
            UserAvatar(url: owner.imageURL)
            Text(owner.name ?? owner.id)
            Button {
                Task {
                    try await feed.follow(request: .init(source: feed.fid, target: targetFeed.fid))
                }
            } label: {
                Text("Follow")
            }
            
            Button {
                Task {
                    try await feed.follow(request: .init(request: true, source: feed.fid, target: targetFeed.fid))
                }
            } label: {
                Text("Request to follow")
            }
        }
    }
}
