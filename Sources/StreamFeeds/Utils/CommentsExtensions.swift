//
//  CommentsExtensions.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 26.5.25.
//

import StreamCore

extension CommentResponse {
    
    var toThreadedComment: ThreadedCommentResponse {
        ThreadedCommentResponse(
            attachments: attachments,
            createdAt: createdAt,
            custom: custom,
            deletedAt: deletedAt,
            id: id,
            latestReactions: latestReactions,
            mentionedUserIds: mentionedUserIds,
            meta: nil, //TODO: what's this?
            objectId: objectId,
            objectType: objectType,
            parentId: parentId,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups,
            replies: nil,
            replyCount: replyCount,
            text: text,
            updatedAt: updatedAt,
            user: user
        )
    }
}
