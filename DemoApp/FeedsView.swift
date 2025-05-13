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
    @State var showActivityOptions = false
    @State var addImage = false
    
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
                            if let parent = activity.parent {
                                Text("\(activity.user.name ?? activity.user.id) reposted")
                                ActivityView(user: parent.user, text: parent.text)
                            } else {
                                ActivityView(user: activity.user, text: activity.text)
                            }
                            
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
                                
                                HStack {
                                    Button {
                                        Task {
                                            do {
                                                try await feed.repost(activityId: activity.id, text: nil)
                                            } catch {
                                                print("===== \(error)")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                    
                                    Text("\(activity.shareCount ?? 0)")
                                }
                                
                                HStack {
                                    Button {
                                        Task {
                                            do {
                                                if activity.ownBookmarks == nil {
                                                    try await feed.addBookmark(activityId: activity.id)
                                                } else {
                                                    try await feed.removeBookmark(activityId: activity.id)
                                                }
                                            } catch {
                                                print("===== \(error)")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: activity.ownBookmarks != nil ? "bookmark.fill" : "bookmark")
                                    }
                                    
                                    Text("\(activity.bookmarkCount)")
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
                        showActivityOptions = true
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
        .confirmationDialog("Add Activity", isPresented: $showActivityOptions) {
            Button("With Image") {
                showAddActivity = true
                addImage = true
            }
            Button("Without Image") {
                showAddActivity = true
                addImage = false
            }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Add activity", isPresented: $showAddActivity) {
            TextField("Activity name", text: $activityName)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                Task {
                    do {
                        var attachments = [ActivityAttachment]()
                        if addImage {
                            let url = "https://morethandigital.info/wp-content/uploads/2017/03/10-Top-Webseiten-für-gratis-lizenzfreie-Bilder-1024x682.jpeg"
                            let attachment = ActivityAttachment(assetUrl: url, custom: nil, imageUrl: url, liveCallCid: nil, type: "image", url: url)
                            attachments.append(attachment)
                        }
                        _ = try await feed.addActivity(text: activityName, attachments: attachments)
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
            Color(UIColor.secondarySystemBackground)
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

struct ActivityView: View {
    
    let user: UserResponse
    let text: String
    var attachments: [ActivityAttachment]?
    
    
    var body: some View {
        HStack {
            UserAvatar(url: user.imageURL)
            VStack(alignment: .leading) {
                Text(user.name ?? user.id)
                    .font(.caption)
                    .bold()
                Text(text)
                if let attachment = attachments?.first {
                    AsyncImage(url: URL(string: attachment.url)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color(UIColor.secondarySystemBackground)
                    }
                    .frame(height: 200)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
