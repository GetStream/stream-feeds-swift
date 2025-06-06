//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

public class ActivityState: ObservableObject {
    @Published public var comments = [ThreadedCommentResponse]()
}
