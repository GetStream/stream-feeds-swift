//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import SwiftUI
import StreamCore
import StreamFeeds

struct LoginView: View {
    let onCredentialsTapped: (UserCredentials) -> ()

    @State private var showsConfiguration = false
    
    var body: some View {
        VStack {
            Image(.streamMark)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
                .padding(.all, 24)

            Text("Welcome to Stream Feeds")
                .font(.title)
                .padding(.all, 8)
            
            Button("Configuration") {
                showsConfiguration = true
            }
            .buttonStyle(.borderedProminent)

            Text("Select a user to try the iOS SDK")
                .font(.callout)
                .padding(.all, 8)
                .padding(.bottom, 16)

            List(UserCredentials.builtIn) { credentials in
                Button {
                    onCredentialsTapped(credentials)
                } label: {
                    RowView(credentials: credentials)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)

            Spacer()
        }
        .sheet(isPresented: $showsConfiguration) {
            AppConfigurationView()
        }
    }
}

extension LoginView {
    struct RowView: View {
        let credentials: UserCredentials

        private let imageSize: CGFloat = 44

        var body: some View {
            HStack {
                AsyncImage(url: credentials.user.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color(UIColor.secondarySystemBackground)
                }
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(credentials.user.name)
                    Text("Stream test account")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.forward")
                    .renderingMode(.template)
            }
        }
    }

}

#Preview {
    LoginView(onCredentialsTapped: { _ in })
}
