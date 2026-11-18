//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import UIKit
import UserNotifications

@MainActor struct Snippets_10_01_PushNotifications {
    var client: FeedsClient!
    var feedsClient: FeedsClient!

    func configuringPushNotifications(
        apiKey: APIKey,
        user: User,
        token: UserToken,
        tokenProvider: @escaping UserTokenProvider
    ) {
        let notificationsConfig = PushNotificationsConfig(
            pushProviderInfo: PushProviderInfo(name: "apn", pushProvider: .apn)
        )

        let config = FeedsConfig(pushNotificationsConfig: notificationsConfig)
        let feedsClient = FeedsClient(
            apiKey: apiKey,
            user: user,
            token: token,
            feedsConfig: config,
            tokenProvider: tokenProvider
        )

        suppressUnusedWarning(feedsClient)
    }

    func removingDevices(savedToken: String) async throws {
        try await feedsClient.deleteDevice(deviceId: savedToken)
    }

    func listingDevices() async throws {
        let devices = try await client.queryDevices()

        suppressUnusedWarning(devices)
    }
}

enum Snippets_10_01_PushNotificationsAppDelegate {
    @MainActor final class AppState {
        static let shared = AppState()
        var pushToken: String?
    }

    class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {
            UNUserNotificationCenter.current().delegate = self
            setupRemoteNotifications()
            return true
        }

        func application(
            _ application: UIApplication,
            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
            let deviceToken = deviceToken.map { String(format: "%02x", $0) }.joined()
            AppState.shared.pushToken = deviceToken
        }

        nonisolated func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            log.debug("push notification received \(response.notification.request.content)")
        }

        func setupRemoteNotifications() {
            UNUserNotificationCenter
                .current()
                .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    if granted {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
        }
    }

    final class PushTokenRegistration {
        var pushToken: String?
        var feedsClient: FeedsClient?

        private func setPushToken() {
            if let pushToken, let feedsClient {
                Task {
                    do {
                        try await feedsClient.createDevice(id: pushToken)
                    } catch {
                        print("Failed to register the device: \(error)")
                    }
                }
            }
        }
    }
}
