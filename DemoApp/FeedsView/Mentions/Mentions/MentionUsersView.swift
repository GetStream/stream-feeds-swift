//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

/// View for the mentioned users.
public struct MentionUsersView: View {
    private let itemHeight: CGFloat = 60

    var users: [UserData]
    var userSelected: (UserData) -> Void

    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    MentionUserView(
                        user: user,
                        userSelected: userSelected
                    )
                }
            }
        }
        .frame(height: viewHeight)
        .background(Color.secondary)
        .modifier(ShadowModifier())
        .padding(.all, 8)
        .animation(.spring(), value: true)
    }

    private var viewHeight: CGFloat {
        if users.count > 3 {
            3 * itemHeight
        } else {
            CGFloat(users.count) * itemHeight
        }
    }
}

/// View for one user that can be mentioned.
public struct MentionUserView: View {
    var user: UserData
    var userSelected: (UserData) -> Void

    public var body: some View {
        HStack {
            UserAvatar(url: user.imageURL)
            Text(user.name ?? user.id)
                .lineLimit(1)
            Spacer()
            Text("@")
                .font(.title)
                .foregroundColor(.blue)
        }
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    userSelected(user)
                }
        )
    }
}
