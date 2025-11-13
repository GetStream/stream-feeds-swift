//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedsConfig: Sendable {
    /// Allows to inject a custom API client for uploading attachments, if not specified, `StreamCDNClient` is used.
    /// If a custom `AttachmentUploader` is provided, the custom `CDNClient` won't be used. You should use 1 of them only.
    public var customCDNClient: CDNClient?
    
    public let pushNotificationsConfig: PushNotificationsConfig
    
    public init(
        customCDNClient: CDNClient? = nil,
        pushNotificationsConfig: PushNotificationsConfig = .default
    ) {
        self.customCDNClient = customCDNClient
        self.pushNotificationsConfig = pushNotificationsConfig
    }
    
    /// A delay in seconds until feed own capabilities are fetched for feeds delivered through web-socket and there is no cached data available.
    var automaticFeedOwnCapabilitiesFetchDelay: Int = 5
}

extension FeedsConfig {
    public static let `default` = FeedsConfig()
}
