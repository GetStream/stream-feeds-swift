//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

/// Default implementation of the commands container.
struct CommandsContainerView: View {
    var suggestions: [String: Any]
    var handleCommand: ([String: Any]) -> Void

    var body: some View {
        ZStack {
            if let suggestedUsers = suggestions["mentions"] as? [UserData], !suggestedUsers.isEmpty {
                MentionUsersView(
                    users: suggestedUsers,
                    userSelected: { user in
                        handleCommand(["user": user])
                    }
                )
            }
        }
    }
}
