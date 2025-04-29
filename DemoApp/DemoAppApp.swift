//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 24.4.25.
//

import SwiftUI
import StreamFeeds

@main
struct DemoAppApp: App {
    
    let feed = Feed(id: "123")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
