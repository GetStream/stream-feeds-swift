//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedsConfig: Sendable {
    /// Allows to inject a custom API client for uploading attachments, if not specified, `StreamCDNClient` is used.
    /// If a custom `AttachmentUploader` is provided, the custom `CDNClient` won't be used. You should use 1 of them only.
    public var customCDNClient: CDNClient?
    
    /// Whether state layer objects refetch their loaded data after the web-socket reconnects. Default is `true`.
    ///
    /// When turned off, call `get()` or `getOrCreate()` after a reconnection for updating the data.
    /// These calls also resume watching feeds whose query has `watch` set.
    public var isAutomaticSyncOnReconnectEnabled: Bool
    
    public let pushNotificationsConfig: PushNotificationsConfig
    
    public init(
        customCDNClient: CDNClient? = nil,
        isAutomaticSyncOnReconnectEnabled: Bool = true,
        pushNotificationsConfig: PushNotificationsConfig = .default
    ) {
        self.customCDNClient = customCDNClient
        self.isAutomaticSyncOnReconnectEnabled = isAutomaticSyncOnReconnectEnabled
        self.pushNotificationsConfig = pushNotificationsConfig
    }
}

extension FeedsConfig {
    public static let `default` = FeedsConfig()
}
