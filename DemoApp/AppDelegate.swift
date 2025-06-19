//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Network
import StreamCore
import StreamFeeds
import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Xcode 26 beta workaround
        nw_tls_create_options()
        
        UNUserNotificationCenter.current().delegate = self
        setUpRemoteNotifications()

        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let deviceToken = deviceToken.map { String(format: "%02x", $0) }.joined()
        log.debug("device token received \(deviceToken)")
        AppState.shared.pushToken = deviceToken
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        log.debug("push notification received \(userInfo)")
    }

    // MARK: - Private Helpers

    private func setUpRemoteNotifications() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                if granted {
                    Task { @MainActor in
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
    }
}
