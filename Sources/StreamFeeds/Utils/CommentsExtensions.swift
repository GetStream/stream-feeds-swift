//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore

extension CommentResponse {
    
    var toThreadedComment: ThreadedCommentResponse {
        ThreadedCommentResponse(
            attachments: attachments,
            confidenceScore: confidenceScore,
            controversyScore: controversyScore,
            createdAt: createdAt,
            custom: custom,
            deletedAt: deletedAt,
            downvoteCount: downvoteCount,
            id: id,
            latestReactions: latestReactions,
            mentionedUsers: mentionedUsers,
            meta: nil,
            moderation: moderation,
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
