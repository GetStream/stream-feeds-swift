//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

struct FeedsListView: View {
    let client: FeedsClient
    let feed: Feed
    let storiesFeed: Feed
    @ObservedObject var state: FeedState
    @ObservedObject var storiesState: FeedState
    
    @State var commentsActivity: ActivityData?
    @State var activityName = ""
    @State var comment = ""
    @State var showActivityOptions = false
    @State var addImage = false
    @State var activityToUpdate: ActivityData?
    @State var updatedActivityText = ""
    @State var activityToDelete: ActivityData?
    @State private var bannerError: Error?
    @State var selectedStory: ActivityData?
    
    init(
        feed: Feed,
        storiesFeed: Feed,
        client: FeedsClient
    ) {
        self.client = client
        self.feed = feed
        self.storiesFeed = storiesFeed
        state = feed.state
        storiesState = storiesFeed.state
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 16) {
                        ForEach(storiesState.activities) { activity in
                            if let image = activity.user.image, let url = URL(string: image) {
                                Button {
                                    selectedStory = activity
                                } label: {
                                    UserAvatar(url: url)
                                }
                                .overlay(
                                    Circle().stroke(Color.purple, lineWidth: 2)
                                )
                                .padding(.all, 2)
                            }
                        }
                    }
                }
                .padding()
                .sheet(item: $selectedStory) { story in
                    let sources: [MediaAttachment] = story.attachments.compactMap { attachment in
                        guard let assetUrl = attachment.assetUrl, let url = URL(string: assetUrl) else {
                            return nil
                        }
                        return MediaAttachment(
                            url: url,
                            type: attachment.type == "video" ? .video : .image,
                            uploadingState: nil
                        )
                    }
                    ImageAttachmentView(
                        activity: story,
                        sources: sources,
                        width: UIScreen.main.bounds.width,
                        imageTapped: { _ in }
                    )
                }
                
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
                    log.error("Failed fetching more activities", error: error)
                    bannerError = error
                }
            })
        }
        .refreshable { await refresh() }
        .modifier(AddButtonModifier(addItemShown: $showActivityOptions, buttonShown: true))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $commentsActivity) { activity in
            CommentsView(activityId: activity.id, feed: feed, feedsClient: client)
                .modifier(PresentationDetentModifier())
        }
        .onLoad {
            await refresh()
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
                            bannerError = error
                        }
                    }
                }
            }
            .disabled(updatedActivityText.trimmed.isEmpty)
        }
        .alert(
            "Delete Activity",
            isPresented: .init(
                get: { activityToDelete != nil },
                set: { if !$0 { activityToDelete = nil } }
            ),
            actions: {
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
                                bannerError = error
                            }
                        }
                    }
                }
            },
            message: {
                Text("Are you sure you want to delete this activity?")
            }
        )
    }
    
    func refresh() async {
        do {
            try await feed.getOrCreate()
            try await storiesFeed.getOrCreate()
        } catch {
            bannerError = error
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
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color(UIColor.secondarySystemBackground)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

struct ActivityView: View {
    @State var previewImage: UIImage?
    @State var selectedAttachment: Attachment?
    
    let user: UserData
    let ownCapabilities: Set<FeedOwnCapability>
    let text: String
    var attachments: [Attachment]?
    var activity: ActivityData
    
    let utils = Utils.shared
    
    var body: some View {
        HStack(alignment: .top) {
            UserAvatar(url: user.imageURL)
            VStack(alignment: .leading) {
                Text(user.name ?? user.id)
                    .font(.caption)
                    .bold()

                LinkDetectionTextView(activity: activity)
                
                if !activity.attachments.isEmpty {
                    ImageAttachmentView(
                        activity: activity,
                        sources: sources,
                        width: UIScreen.main.bounds.width - 80,
                        imageTapped: { index in
                            if attachments?[index].type == "video" {
                                selectedAttachment = attachments?[index]
                            }
                        }
                    )
                    .sheet(item: $selectedAttachment) { _ in
                        VideoPlayerView(
                            attachment: $selectedAttachment
                        )
                    }
                    .cornerRadius(16)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .modifier(ShowProfileModifier(activity: activity))
    }
    
    private var sources: [MediaAttachment] {
        activity.attachments.compactMap { attachment in
            guard let assetUrl = attachment.assetUrl, let url = URL(string: assetUrl) else {
                return nil
            }
            return MediaAttachment(
                url: url,
                type: attachment.type == "video" ? .video : .image,
                uploadingState: nil
            )
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

struct VideoPlayIcon: View {
    var width: CGFloat = 24
    
    var body: some View {
        Image(systemName: "play.fill")
            .customizable()
            .frame(width: width)
            .foregroundColor(.white)
            .modifier(ShadowModifier())
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
