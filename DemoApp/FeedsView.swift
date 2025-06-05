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
    @State var feed: Feed
    @StateObject var state: FeedState
    
    @State var showAddActivity = false
    @State var commentsActivity: ActivityInfo?
    @State var activityName = ""
    @State var comment = ""
    @State var showActivityOptions = false
    @State var addImage = false
    @State var activityToUpdate: ActivityInfo?
    @State var updatedActivityText = ""
    @State var activityToDelete: ActivityInfo?
    @State var profileShown = false
    
    init(credentials: UserCredentials) {
        let feedsClient = FeedsClient(
            apiKey: .init("892s22ypvt6m"),
            user: credentials.user,
            token: credentials.token
        )
        self.feedsClient = feedsClient
        let feed = feedsClient.feed(group: "user", id: credentials.user.id)
        _feed = State(initialValue: feed)
        _state = StateObject(wrappedValue: feed.state)
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
                                ActivityView(
                                    user: parent.user,
                                    text: parent.text ?? "",
                                    attachments: parent.attachments,
                                    activity: activity,
                                    onUpdate: { activity, text in
                                        activityToUpdate = activity
                                        updatedActivityText = text
                                    },
                                    onDelete: { activity in
                                        activityToDelete = activity
                                    }
                                )
                            } else {
                                ActivityView(
                                    user: activity.user,
                                    text: activity.text ?? "",
                                    attachments: activity.attachments,
                                    activity: activity,
                                    onUpdate: { activity, text in
                                        activityToUpdate = activity
                                        updatedActivityText = text
                                    },
                                    onDelete: { activity in
                                        activityToDelete = activity
                                    }
                                )
                            }
                            
                            HStack(spacing: 32) {
                                Spacer()
                                
                                HStack {
                                    Button {
                                        commentsActivity = activity
                                    } label: {
                                        Image(systemName: "message")
                                    }
                                    
                                    Text("\(activity.commentCount)")
                                }

                                HStack {
                                    Button {
                                        Task {
                                            do {
                                                if activity.ownReactions.isEmpty {
                                                    try await feed.addReaction(activityId: activity.id, request: .init(type: "heart"))
                                                } else {
                                                    try await feed.deleteReaction(activityId: activity.id, type: "heart")
                                                }
                                            } catch {
                                                print("===== \(error)")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: !activity.ownReactions.isEmpty ? "heart.fill" : "heart")
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
                                    
                                    Text("\(activity.shareCount)")
                                }
                                
                                HStack {
                                    Button {
                                        Task {
                                            do {
                                                if activity.ownBookmarks.isEmpty {
                                                    try await feed.addBookmark(activityId: activity.id)
                                                } else {
                                                    try await feed.deleteBookmark(activityId: activity.id)
                                                }
                                            } catch {
                                                print("===== \(error)")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: !activity.ownBookmarks.isEmpty ? "bookmark.fill" : "bookmark")
                                    }
                                    
                                    Text("\(activity.bookmarkCount)")
                                }
                                
                                Spacer()
                            }
                            
                            Divider()
                        }
                    }
                }
            }
            .modifier(AddButtonModifier(addItemShown: $showActivityOptions, buttonShown: true))
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("Stream Feeds")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        profileShown = true
                    } label: {
                        Image(systemName: "person")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    UserAvatar(url: feedsClient.user.imageURL)
                }
            })
        }
        .sheet(isPresented: $profileShown, content: {
            ProfileView(feed: feed, feedsClient: feedsClient)
        })
        .sheet(item: $commentsActivity) { activity in
            CommentsView(activityId: activity.id, feedsClient: feedsClient)
                .modifier(PresentationDetentModifier())
        }
        .onAppear {
            Task {
                do {
                    try await self.feed.getOrCreate(
                        request: .init(
                            data: .init(members: [.init(userId: feedsClient.user.id)], visibility: .public),
                            followerPagination: .init(limit: 10),
                            followingPagination: .init(limit: 10),
                            memberPagination: .init(limit: 10),
                            watch: true
                        )
                    )
                } catch {
                    print("====== \(error)")
                }
            }
        }
        .sheet(isPresented: $showActivityOptions, content: {
            if #available(iOS 16.0, *) {
                ActivityComposerView(feed: feed, feedsClient: feedsClient)
                    .presentationDetents([.medium])
            } else {
                ActivityComposerView(feed: feed, feedsClient: feedsClient)
            }
        })
        .alert("Add activity", isPresented: $showAddActivity) {
            TextField("Activity name", text: $activityName)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                Task {
                    do {
                        var attachments = [Attachment]()
                        if addImage {
                            let url = "https://morethandigital.info/wp-content/uploads/2017/03/10-Top-Webseiten-für-gratis-lizenzfreie-Bilder-1024x682.jpeg"
                            let attachment = Attachment(assetUrl: url, custom: [:], imageUrl: url)
                            attachments.append(attachment)
                        }
                        _ = try await feed.addActivity(
                            request: .init(
                                attachments: attachments, fids: [feed.fid], text: activityName, type: "activity"
                            )
                        )
                        activityName = ""
                    } catch {
                        print("======= \(error)")
                    }
                }
            }
        }
        .alert("Update activity", isPresented: .init(
            get: { activityToUpdate != nil },
            set: { if !$0 { activityToUpdate = nil } }
        )) {
            TextField("Activity text", text: $updatedActivityText)
            Button("Cancel", role: .cancel) {
                activityToUpdate = nil
            }
            Button("Update") {
                if let activity = activityToUpdate {
                    Task {
                        do {                            
                            _ = try await feed.updateActivity(
                                id: activity.id,
                                request: .init(attachments: activity.attachments, text: updatedActivityText)
                            )
                            activityToUpdate = nil
                        } catch {
                            print("======= \(error)")
                        }
                    }
                }
            }
        }
        .alert("Delete Activity", isPresented: .init(
            get: { activityToDelete != nil },
            set: { if !$0 { activityToDelete = nil } }
        )) {
            Text("Are you sure you want to delete this activity?")
            Button("Cancel", role: .cancel) {
                activityToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let activity = activityToDelete {
                    Task {
                        do {
                            _ = try await feed.deleteActivity(id: activity.id)
                            activityToDelete = nil
                        } catch {
                            print("======= \(error)")
                        }
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

extension FeedResponse: Identifiable {}

struct ActivityView: View {
    
    let user: UserResponse
    let text: String
    var attachments: [Attachment]?
    var activity: ActivityInfo
    var onUpdate: (ActivityInfo, String) -> Void
    var onDelete: (ActivityInfo) -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            UserAvatar(url: user.imageURL)
            VStack(alignment: .leading) {
                Text(user.name ?? user.id)
                    .font(.caption)
                    .bold()
                Text(text)
                if let attachment = attachments?.first, let url = attachment.imageUrl {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color(UIColor.secondarySystemBackground)
                    }
                    .frame(height: 200)
                    .cornerRadius(16)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .contextMenu {
            Button {
                onUpdate(activity, text)
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                onDelete(activity)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct AddButtonModifier: ViewModifier {
    
    @Binding var addItemShown: Bool
    var buttonShown: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                addItemShown = true
                            }
                        } label: {
                            AddButtonView()
                        }
                        .padding()
                    }
                }
                .opacity(buttonShown ? 1 : 0)
                .transition(.identity)
            )
    }
}

struct AddButtonView: View {
    var body: some View {
        Image(systemName: "plus")
            .padding(.all, 24)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

struct PresentationDetentModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.presentationDetents([.medium])
        } else {
            content
        }
    }
}
