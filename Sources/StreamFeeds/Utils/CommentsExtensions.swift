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
            confidenceScore: confidenceScore,
            createdAt: createdAt,
            custom: custom,
            deletedAt: deletedAt,
            downvoteCount: downvoteCount,
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
            score: score,
            status: status,
            text: text,
            updatedAt: updatedAt,
            upvoteCount: upvoteCount,
            user: user
        )
    }
}
