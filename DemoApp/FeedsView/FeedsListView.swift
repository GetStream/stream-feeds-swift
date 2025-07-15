//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct FeedsListView: View {
    let client: FeedsClient
    let feed: Feed
    @ObservedObject var state: FeedState
    
    @State var commentsActivity: ActivityData?
    @State var activityName = ""
    @State var comment = ""
    @State var showActivityOptions = false
    @State var addImage = false
    @State var activityToUpdate: ActivityData?
    @State var updatedActivityText = ""
    @State var activityToDelete: ActivityData?
    @State private var bannerError: Error?
    
    init(feed: Feed, client: FeedsClient) {
        self.client = client
        self.feed = feed
        state = feed.state
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                ForEach(state.activities) { activity in
                    FeedsListRowView(
                        activity: activity,
                        feed: feed,
                        client: client,
                        onDelete: { activity in
                            activityToDelete = activity
                        },
                        onUpdate: { activity, text in
                            activityToUpdate = activity
                            updatedActivityText = text
                        },
                        onComment: { activity in
                            commentsActivity = activity
                        }
                    )
                }
            }
            .errorBanner(for: $bannerError)
            .onScrollPaginationChanged(onBottomThreshold: {
                guard state.canLoadMoreActivities else { return }
                do {
                    try await feed.queryMoreActivities(limit: 10)
                } catch {
                    bannerError = error
                }
            })
        }
        .modifier(AddButtonModifier(addItemShown: $showActivityOptions, buttonShown: true))
        .padding(.top)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $commentsActivity) { activity in
            CommentsView(activityId: activity.id, feed: feed, feedsClient: client)
                .modifier(PresentationDetentModifier())
        }
        .onAppear {
            Task {
                do {
                    try await feed.getOrCreate()
                } catch {
                    bannerError = error
                }
            }
        }
        .sheet(isPresented: $showActivityOptions, content: {
            if #available(iOS 16.0, *) {
                ActivityComposerView(feed: feed, feedsClient: client)
                    .presentationDetents([.medium])
            } else {
                ActivityComposerView(feed: feed, feedsClient: client)
            }
        })
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
                            log.error("Error updating an activity \(error)")
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
                            log.error("Error deleting an activity \(error)")
                        }
                    }
                }
            }
        }
    }
}

struct UserAvatar: View {
    let url: URL?
    var size: CGFloat = 36
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Color(UIColor.secondarySystemBackground)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

struct ActivityView: View {
    let user: UserData
    let ownCapabilities: [FeedOwnCapability]
    let text: String
    var attachments: [Attachment]?
    var activity: ActivityData
    
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
