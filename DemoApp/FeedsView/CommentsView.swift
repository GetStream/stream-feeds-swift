//
//  CommentsView.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 24.5.25.
//

import SwiftUI
import StreamFeeds

struct CommentsView: View {
    
    let activityId: String
    let userId: String
    
    @State var expandedCommentRepliesId: String?
    @State var nestedCommentRepliesId: String?
    
    @State var activity: Activity
    @StateObject var state: ActivityState
    
    @State var addCommentShown = false
    @State var addCommentRepliesShown = false
    @State var editCommentShown = false
    @State var editCommentId: String?
    @State var comment = ""
    
    init(activityId: String, fid: FeedId, feedsClient: FeedsClient) {
        self.activityId = activityId
        let activity = feedsClient.activity(for: activityId, in: fid)
        _activity = State(initialValue: activity)
        _state = StateObject(wrappedValue: activity.state)
        self.userId = feedsClient.user.id
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Comments")
                    .font(.headline)
                ForEach(state.comments) { comment in
                    VStack {
                        CommentView(
                            user: comment.user,
                            text: comment.text ?? "",
                            onEdit: {
                                editCommentId = comment.id
                                editCommentShown = true
                                self.comment = comment.text ?? ""
                            },
                            onDelete: {
                                Task {
                                    try await activity.removeComment(commentId: comment.id)
                                }
                            }
                        )
                        
                        ActivityActionsView(
                            comment: comment,
                            activity: activity,
                            userId: userId,
                            expandedCommentRepliesId: $expandedCommentRepliesId,
                            addCommentRepliesShown: $addCommentRepliesShown,
                            containsUserReaction: comment.containsUserReaction(with: userId)
                        )
                        
                        if comment.id == expandedCommentRepliesId, let replies = comment.replies {
                            ForEach(replies) { reply in
                                VStack {
                                    CommentView(
                                        user: reply.user,
                                        text: reply.text ?? "",
                                        onEdit: {
                                            editCommentId = reply.id
                                            editCommentShown = true
                                            self.comment = reply.text ?? ""
                                        },
                                        onDelete: {
                                            Task {
                                                try await activity.removeComment(commentId: reply.id)
                                            }
                                        }
                                    )
                                    
                                    ActivityActionsView(
                                        comment: reply,
                                        activity: activity,
                                        userId: userId,
                                        expandedCommentRepliesId: $nestedCommentRepliesId,
                                        addCommentRepliesShown: $addCommentRepliesShown,
                                        containsUserReaction: reply.containsUserReaction(with: userId)
                                    )
                                    
                                    if reply.id == nestedCommentRepliesId, let nestedReplies = reply.replies {
                                        ForEach(nestedReplies) { nested in
                                            VStack {
                                                CommentView(
                                                    user: nested.user,
                                                    text: nested.text ?? "",
                                                    onEdit: {
                                                        editCommentId = nested.id
                                                        editCommentShown = true
                                                        self.comment = nested.text ?? ""
                                                    },
                                                    onDelete: {
                                                        Task {
                                                            try await activity.removeComment(commentId: nested.id)
                                                        }
                                                    }
                                                )
                                                
                                                ActivityActionsView(
                                                    comment: nested,
                                                    activity: activity,
                                                    userId: userId,
                                                    expandedCommentRepliesId: $nestedCommentRepliesId,
                                                    addCommentRepliesShown: $addCommentRepliesShown,
                                                    containsUserReaction: nested.containsUserReaction(with: userId)
                                                )
                                            }
                                            .padding(.leading, 40)
                                        }
                                    }
                                }
                                .padding(.leading, 40)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .onChange(of: expandedCommentRepliesId, perform: { value in
            if expandedCommentRepliesId == nil {
                nestedCommentRepliesId = nil
            }
        })
        .modifier(AddButtonModifier(addItemShown: $addCommentShown, buttonShown: true))
        .alert("Add Comment", isPresented: $addCommentShown) {
            TextField("Insert comment", text: $comment)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                Task {
                    do {
                        try await activity.addComment(
                            request: .init(comment: comment)
                        )
                        comment = ""
                    } catch {
                        print("======= \(error)")
                    }
                }
            }
        }
        .alert("Add Reply", isPresented: $addCommentRepliesShown) {
            TextField("Insert reply", text: $comment)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                Task {
                    do {
                        try await activity.addComment(
                            request: .init(
                                comment: comment,
                                parentId: nestedCommentRepliesId ?? expandedCommentRepliesId
                            )
                        )
                        comment = ""
                    } catch {
                        print("======= \(error)")
                    }
                }
            }
        }
        .alert("Edit comment", isPresented: $editCommentShown) {
            TextField("Edit comment", text: $comment)
            Button("Cancel", role: .cancel) { }
            Button("Edit") {
                Task {
                    do {
                        if let commentId = editCommentId {
                            try await activity.updateComment(
                                commentId: commentId,
                                request: .init(comment: comment)
                            )
                        }
                        editCommentId = nil
                        comment = ""
                    } catch {
                        print("======= \(error)")
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await activity.getComments(objectId: activityId, objectType: "activity", depth: 2)
            }
        }
    }
}

extension CommentData {
    //TODO: maybe expose own reactions.
    func containsUserReaction(with id: String) -> Bool {
        latestReactions.contains(where: { $0.user.id == id })
    }
}

struct CommentView: View {
    
    var user: UserData
    var text: String
    var onEdit: () -> ()
    var onDelete: () -> ()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name ?? user.id)
                    .font(.headline)
                Text(text)
                //TODO: attachments
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .contextMenu {
            //TODO: permissions / capabilities
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct ActivityActionsView: View {
    
    var comment: CommentData
    var activity: Activity
    var userId: String
    @Binding var expandedCommentRepliesId: String?
    @Binding var addCommentRepliesShown: Bool
    var containsUserReaction: Bool
    
    var body: some View {
        HStack {
            Button {
                Task {
                    if !containsUserReaction {
                        try await activity.addCommentReaction(commentId: comment.id, request: .init(type: "heart"))
                    } else {
                        try await activity.removeCommentReaction(commentId: comment.id, type: "heart")
                    }
                }
            } label: {
                Text(!containsUserReaction ? "Like" : "Unlike")
            }
            
            Button {
                withAnimation {
                    expandedCommentRepliesId = comment.id
                    addCommentRepliesShown = true
                }
            } label: {
                Text("Reply")
            }
            
            Spacer()
            
            if comment.replyCount > 0 {
                Button {
                    withAnimation {
                        if expandedCommentRepliesId == comment.id {
                            expandedCommentRepliesId = nil
                        } else {
                            expandedCommentRepliesId = comment.id
                        }
                    }
                } label: {
                    Text("Replies (\(comment.replyCount))")
                }

            }
            
            Image(systemName: containsUserReaction ? "heart.fill" : "heart")
            Text("\(comment.reactionGroups["heart"]?.count ?? 0)")
        }
        .padding(.leading)
    }
}
