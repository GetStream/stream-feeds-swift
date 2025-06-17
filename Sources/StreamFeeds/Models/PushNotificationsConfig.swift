//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct PushNotificationsConfig: Sendable, Equatable {
    /// Config for regular push notifications.
    public let pushProviderInfo: PushProviderInfo
    
    public init(pushProviderInfo: PushProviderInfo) {
        self.pushProviderInfo = pushProviderInfo
    }
}

public extension PushNotificationsConfig {
    /// Default push notifications config.
    static let `default` = PushNotificationsConfig(
        pushProviderInfo: PushProviderInfo(name: "apn", pushProvider: .apn)
    )
    
    /// Creates a push notifications config with the provided parameters.
    /// - Parameters:
    ///  - pushProviderName: the push provider name.
    /// - Returns: `PushNotificationsConfig`.
    static func make(pushProviderName: String, voipProviderName: String) -> PushNotificationsConfig {
        PushNotificationsConfig(
            pushProviderInfo: PushProviderInfo(name: pushProviderName, pushProvider: .apn)
        )
    }
}

public struct PushProviderInfo: Sendable, Equatable {
    public let name: String
    public let pushProvider: PushNotificationsProvider

    public init(name: String, pushProvider: PushNotificationsProvider) {
        self.name = name
        self.pushProvider = pushProvider
    }
}

/// A type that represents the supported push providers.
public struct PushNotificationsProvider: RawRepresentable, Hashable, ExpressibleByStringLiteral, Sendable {
    public static let firebase: Self = "firebase"
    public static let apn: Self = "apn"
    
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
