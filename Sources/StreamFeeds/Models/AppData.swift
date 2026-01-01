//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct AppData: Equatable, Sendable {
    public let asyncUrlEnrichEnabled: Bool
    public let autoTranslationEnabled: Bool
    public let fileUploadConfig: FileUploadConfigData
    public let imageUploadConfig: FileUploadConfigData
    public let name: String
}

// MARK: - Model Conversions

extension AppResponseFields {
    func toModel() -> AppData {
        AppData(
            asyncUrlEnrichEnabled: asyncUrlEnrichEnabled,
            autoTranslationEnabled: autoTranslationEnabled,
            fileUploadConfig: fileUploadConfig.toModel(),
            imageUploadConfig: imageUploadConfig.toModel(),
            name: name
        )
    }
}
