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
    let client: FeedsClient
    @ObservedObject var state: FeedState
    
    @State var followSuggestions = [FeedData]()
    
    init(feed: Feed, client: FeedsClient) {
        self.feed = feed
        self.client = client
        self.state = feed.state
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Feed members")
                        .font(.headline)
                    VStack {
                        ForEach(feed.state.members) { member in
                            Text(member.user.name ?? member.user.id)
                        }
                    }
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
                                            request: .init(sourceFid: request.sourceFeed.fid, targetFid: request.targetFeed.fid)
                                        )
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                                
                                Button {
                                    Task {
                                        try await feed.rejectFollow(
                                            request: .init(sourceFid: request.sourceFeed.fid, targetFid: request.targetFeed.fid)
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
                                    try await feed.unfollow(targetFid: follow.targetFeed.fid)
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
                                    try await feed.unfollow(sourceFid: follow.sourceFeed.fid, targetFid: follow.targetFeed.fid)
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
                    let suggestionsResponse = try await feed.queryFollowSuggestions(limit: 10)
                    followSuggestions = suggestionsResponse
                }
            }
        }
    }
}

struct FollowSuggestionView: View {
    
    let owner: UserData
    let feed: Feed
    let targetFeed: FeedData
    
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
                    //TODO: check how request to follow will work.
                    try await feed.follow(request: .init(source: feed.fid, target: targetFeed.fid))
                }
            } label: {
                Text("Request to follow")
            }
        }
    }
}
