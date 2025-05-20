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
    
    let feed: FlatFeed
    @ObservedObject var state: FeedState
    
    init(feed: FlatFeed) {
        self.feed = feed
        self.state = feed.state
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Following")
                        .font(.headline)
                    ForEach(state.following) { follow in
                        HStack {
                            Text(follow.targetFeed.owner.name ?? follow.targetFeed.owner.id)
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
                            Text(follow.sourceFeed.owner.name ?? follow.sourceFeed.owner.id)
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
                    ForEach(whoToFollow) { credentials in
                        HStack {
                            Text(credentials.user.name)
                            Spacer()
                            Button {
                                Task {
                                    try await feed.follow(request: .init(source: feed.fid, target: credentials.fid))
                                }
                            } label: {
                                Text("Follow")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
    
    var whoToFollow: [UserCredentials] {
        UserCredentials.builtIn.filter { credentials in
            !state.following.map(\.targetFeed.owner.id).contains(credentials.id)
                && credentials.user.id != userId
        }
    }
}

extension Follow: Identifiable {}
