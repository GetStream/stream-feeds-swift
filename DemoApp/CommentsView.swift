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
    @State var commentReplies = [ThreadedCommentResponse]()
    
    @State var activity: Activity
    @StateObject var state: ActivityState
    
    @State var addCommentShown = false
    @State var addCommentRepliesShown = false
    @State var comment = ""
    
    init(activityId: String, feedsClient: FeedsClient) {
        self.activityId = activityId
        let activity = feedsClient.activity(id: activityId)
        self.activity = activity
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
                                
                            },
                            onDelete: {
                                Task {
                                    try await activity.deleteComment(commentId: comment.id)
                                }
                            }
                        )

                        HStack {
                            Button {
                                Task {
                                    if !comment.containsUserReaction(with: userId) {
                                        try await activity.addCommentReaction(commentId: comment.id, request: .init(type: "heart"))
                                    } else {
                                        try await activity.removeCommentReaction(commentId: comment.id)
                                    }
                                }
                            } label: {
                                Text(!comment.containsUserReaction(with: userId) ? "Like" : "Unlike")
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
                                            Task {
                                                self.commentReplies = try await activity.getCommentReplies(commentId: comment.id).comments
                                            }
                                        }
                                    }
                                } label: {
                                    Text("Replies (\(comment.replyCount))")
                                }

                            }
                            
                            Image(systemName: comment.containsUserReaction(with: userId) ? "heart.fill" : "heart")
                            Text("\(comment.reactionGroups?["heart"]?.count ?? 0)")
                        }
                        .padding(.leading)
                        
                        if comment.id == expandedCommentRepliesId {
                            ForEach(commentReplies) { reply in
                                CommentView(
                                    user: reply.user,
                                    text: reply.text ?? "",
                                    onEdit: {
                                        
                                    },
                                    onDelete: {
                                        Task {
                                            try await activity.deleteComment(commentId: reply.id)
                                        }
                                    }
                                )
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
            commentReplies.removeAll()
        })
        .modifier(AddButtonModifier(addItemShown: $addCommentShown, buttonShown: true))
        .alert("Add Comment", isPresented: $addCommentShown) {
            TextField("Insert comment", text: $comment)
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                Task {
                    do {
                        try await activity.addComment(
                            request: .init(comment: comment, objectId: activityId, objectType: "activity")
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
                                objectId: activityId,
                                objectType: "activity",
                                parentId: expandedCommentRepliesId
                            )
                        )
                        comment = ""
                    } catch {
                        print("======= \(error)")
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await activity.getComments(objectId: activityId, objectType: "activity", depth: 1)
            }
        }
    }
}

extension CommentResponse: Identifiable {
    
    //TODO: maybe expose own reactions.
    func containsUserReaction(with id: String) -> Bool {
        latestReactions.map(\.user.id).contains(id)
    }
}

extension ThreadedCommentResponse: Identifiable {}

struct CommentView: View {
    
    var user: UserResponse
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
