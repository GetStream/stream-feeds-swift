//
//  ActivityState.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 24.5.25.
//

import Combine
import Foundation
import StreamCore

public class ActivityState: ObservableObject {
    @Published public var comments = [CommentResponse]()
    //TODO: move this to the comment model.
    @Published public var commentReplies = [String: [ThreadedCommentResponse]]()
}
