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
    
    @State var feedsClient = FeedsClient(
        apiKey: .init("892s22ypvt6m"),
        user: .init(id: "martin"),
        token: UserToken(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFydGluIn0.-8mL49OqMdlvzXR_1IgYboVXXuXFc04r0EvYgko-X8I")
    )
    
    init() {
        LogConfig.level = .debug
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let feed = feedsClient.flatFeed(group: "user", id: "martin")
                    Task {
                        do {
                            try await feed.create(visibility: .public)
                        } catch {
                            print("============ \(error)")
                        }
                    }
                }
        }
    }
}
