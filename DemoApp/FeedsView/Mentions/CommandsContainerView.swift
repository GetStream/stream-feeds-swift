//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

/// Default implementation of the commands container.
struct CommandsContainerView: View {
    var suggestions: [String: Any]
    var handleCommand: ([String: Any]) -> Void

    var body: some View {
        ZStack {
            if let suggestedUsers = suggestions["mentions"] as? [UserData] {
                MentionUsersView(
                    users: suggestedUsers,
                    userSelected: { user in
                        handleCommand(["user": user])
                    }
                )
            }

            // TODO: enable it.
//            if let instantCommands = suggestions["instantCommands"] as? [CommandHandler] {
//                InstantCommandsView(
//                    instantCommands: instantCommands,
//                    commandSelected: { command in
//                        handleCommand(["instantCommand": command])
//                    }
//                )
//            }
        }
    }
}
