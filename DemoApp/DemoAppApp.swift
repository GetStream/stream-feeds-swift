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
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
