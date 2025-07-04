//
//  FeedsView.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 9.5.25.
//

import SwiftUI
import StreamCore
import StreamFeeds

struct FeedsListView: View {
    let client: FeedsClient
    let feed: Feed
    @ObservedObject var state: FeedState
    
    @State var showAddActivity = false
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
            LazyVStack(spacing: 8) {
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
            CommentsView(activityId: activity.id, fid: feed.fid, feedsClient: client)
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
                                attachments: attachments, text: activityName, type: "activity"
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
    let text: String
    var attachments: [Attachment]?
    var activity: ActivityData
    var onUpdate: (ActivityData, String) -> Void
    var onDelete: (ActivityData) -> Void
    
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
