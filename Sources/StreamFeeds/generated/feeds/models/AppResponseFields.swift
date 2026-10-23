//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A type representing the app settings.
public final class AppResponseFields: @unchecked Sendable, Codable, JSONEncodable {
    /// A boolean value determining if async url enrichment is enabled.
    public var asyncUrlEnrichEnabled: Bool
    /// A boolean value determining if auto translation is enabled.
    public var autoTranslationEnabled: Bool
    public var fileUploadConfig: FileUploadConfig
    public var imageUploadConfig: FileUploadConfig
    /// The name of the app.
    public var name: String

    public init(
        asyncUrlEnrichEnabled: Bool,
        autoTranslationEnabled: Bool,
        fileUploadConfig: FileUploadConfig,
        imageUploadConfig: FileUploadConfig,
        name: String
    ) {
        self.asyncUrlEnrichEnabled = asyncUrlEnrichEnabled
        self.autoTranslationEnabled = autoTranslationEnabled
        self.fileUploadConfig = fileUploadConfig
        self.imageUploadConfig = imageUploadConfig
        self.name = name
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case asyncUrlEnrichEnabled = "async_url_enrich_enabled"
        case autoTranslationEnabled = "auto_translation_enabled"
        case fileUploadConfig = "file_upload_config"
        case imageUploadConfig = "image_upload_config"
        case name
    }
}

extension AppResponseFields: Hashable {
    public static func == (lhs: AppResponseFields, rhs: AppResponseFields) -> Bool {
        lhs.asyncUrlEnrichEnabled == rhs.asyncUrlEnrichEnabled &&
            lhs.autoTranslationEnabled == rhs.autoTranslationEnabled &&
            lhs.fileUploadConfig == rhs.fileUploadConfig &&
            lhs.imageUploadConfig == rhs.imageUploadConfig &&
            lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(asyncUrlEnrichEnabled)
        hasher.combine(autoTranslationEnabled)
        hasher.combine(fileUploadConfig)
        hasher.combine(imageUploadConfig)
        hasher.combine(name)
    }
}
