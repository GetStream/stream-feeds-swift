//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 24.4.25.
//

import SwiftUI
import StreamCore
import StreamFeeds

@main
struct DemoAppApp: App {
    
    @AppStorage("userId") var userId: String = ""
        
    var body: some Scene {
        WindowGroup {
            if !userId.isEmpty {
                FeedsView(credentials: UserCredentials.credentials(for: userId))
            } else {
                LoginView { credentials in
                    userId = credentials.user.id
                }
            }
        }
    }
}
