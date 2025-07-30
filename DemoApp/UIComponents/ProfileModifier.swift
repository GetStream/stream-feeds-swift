//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamFeeds
import SwiftUI

struct ShowProfileModifier: ViewModifier {
    let activity: ActivityData
    
    @StateObject var mentionsHandler = MentionsHandler()
    
    func body(content: Content) -> some View {
        content
            .modifier(
                ProfileURLModifier(
                    mentionsHandler: mentionsHandler,
                    activity: activity
                )
            )
    }
}

class MentionsHandler: ObservableObject {
    @Published var selectedUser: UserData?
}

struct ProfileURLModifier: ViewModifier {
    @ObservedObject var mentionsHandler: MentionsHandler
    var activity: ActivityData
    
    @State var showProfile = false
    
    func body(content: Content) -> some View {
        if !activity.mentionedUsers.isEmpty {
            content
                .onOpenURL(perform: { url in
                    if url.absoluteString.contains("getstreamfeeds://mention")
                        && url.pathComponents.count > 2
                        && (mentionsHandler.selectedUser?.id != url.pathComponents[2] || !showProfile) {
                        let userId = url.pathComponents[2]
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            if mentionsHandler.selectedUser == nil {
                                let user = activity.mentionedUsers.first(where: { $0.id == userId })
                                mentionsHandler.selectedUser = user
                                showProfile = true
                            }
                        }
                    }
                })
                .sheet(isPresented: $showProfile, onDismiss: {
                    mentionsHandler.selectedUser = nil
                }, content: {
                    if let user = mentionsHandler.selectedUser {
                        VStack {
                            UserAvatar(url: user.imageURL, size: 80)
                            Text(user.name ?? user.id)
                                .font(.title)
                        }
                    }
                })
        } else {
            content
        }
    }
}
