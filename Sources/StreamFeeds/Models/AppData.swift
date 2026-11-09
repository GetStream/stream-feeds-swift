//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct AppData: Equatable, Sendable {
    public let asyncUrlEnrichEnabled: Bool
    public let autoTranslationEnabled: Bool
    public let fileUploadConfig: FileUploadConfigData
    /// The numeric identifier of the app.
    public let id: Int
    public let imageUploadConfig: FileUploadConfigData
    public let name: String
    /// The region and shard that host the app, as `region.shard`.
    public let placement: String
}

// MARK: - Model Conversions

extension AppResponseFields {
    func toModel() -> AppData {
        AppData(
            asyncUrlEnrichEnabled: asyncUrlEnrichEnabled,
            autoTranslationEnabled: autoTranslationEnabled,
            fileUploadConfig: fileUploadConfig.toModel(),
            id: id,
            imageUploadConfig: imageUploadConfig.toModel(),
            name: name,
            placement: placement
        )
    }
}
