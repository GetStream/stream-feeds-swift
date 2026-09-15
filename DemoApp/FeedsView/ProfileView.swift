//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct ProfileView: View {
    @AppStorage("userId") var userId: String = ""
    
    let feed: Feed
    let client: FeedsClient
    @ObservedObject var state: FeedState
    
    @State var followSuggestions = [FeedData]()
    
    init(feed: Feed, client: FeedsClient) {
        self.feed = feed
        self.client = client
        state = feed.state
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
                    
                    Divider()
                    
                    if !feed.state.followRequests.isEmpty {
                        Text("Follow Requests")
                            .font(.headline)
                        VStack {
                            ForEach(feed.state.followRequests) { request in
                                HStack {
                                    Text(request.sourceFeed.createdBy.name ?? request.sourceFeed.createdBy.id)
                                    Spacer()
                                    Button {
                                        Task {
                                            do {
                                                try await feed.acceptFollow(request.sourceFeed.feed)
                                            } catch {
                                                log.error("Error accepting a follow request \(error)")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    
                                    Button {
                                        Task {
                                            do {
                                                try await feed.rejectFollow(request.sourceFeed.feed)
                                            } catch {
                                                log.error("Error rejecting a follow request \(error)")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                    }
                    
                    Text("Following")
                        .font(.headline)
                    ForEach(state.following) { follow in
                        HStack {
                            Text(follow.targetFeed.createdBy.name ?? follow.targetFeed.createdBy.id)
                            Spacer()
                            Button {
                                Task {
                                    do {
                                        try await feed.unfollow(follow.targetFeed.feed)
                                        withAnimation {
                                            followSuggestions.append(follow.targetFeed)
                                        }
                                    } catch {
                                        log.error("Error unfollowing a feed \(error)")
                                    }
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
                                    do {
                                        try await feed.unfollow(follow.sourceFeed.feed)
                                    } catch {
                                        log.error("Error removing a follower \(error)")
                                    }
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
                                    followedFeed: suggestion.feed,
                                    followSuggestions: $followSuggestions
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
                    do {
                        followSuggestions = try await feed.queryFollowSuggestions(limit: 10)
                    } catch {
                        log.error("Error querying follow suggestions \(error)")
                    }
                }
            }
        }
    }
}

struct FollowSuggestionView: View {
    let owner: UserData
    let feed: Feed
    let followedFeed: FeedId
    @Binding var followSuggestions: [FeedData]
    
    var body: some View {
        VStack {
            UserAvatar(url: owner.imageURL)
            Text(owner.name ?? owner.id)
            Button {
                Task {
                    do {
                        try await feed.follow(followedFeed, createNotificationActivity: true)
                        withAnimation {
                            followSuggestions.removeAll(where: { $0.feed == followedFeed })
                        }
                    } catch {
                        log.error("Error following a feed \(error)")
                    }
                }
            } label: {
                Text("Follow")
            }
        }
    }
}
