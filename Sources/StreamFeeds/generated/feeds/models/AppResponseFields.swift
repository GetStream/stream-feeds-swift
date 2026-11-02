//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A type representing the app settings.
public final class AppResponseFields: Sendable, Decodable {
    /// A boolean value determining if async url enrichment is enabled.
    public let asyncUrlEnrichEnabled: Bool
    /// A boolean value determining if auto translation is enabled.
    public let autoTranslationEnabled: Bool
    public let fileUploadConfig: FileUploadConfig
    public let imageUploadConfig: FileUploadConfig
    /// The name of the app.
    public let name: String

    public init(asyncUrlEnrichEnabled: Bool, autoTranslationEnabled: Bool, fileUploadConfig: FileUploadConfig, imageUploadConfig: FileUploadConfig, name: String) {
        self.asyncUrlEnrichEnabled = asyncUrlEnrichEnabled
        self.autoTranslationEnabled = autoTranslationEnabled
        self.fileUploadConfig = fileUploadConfig
        self.imageUploadConfig = imageUploadConfig
        self.name = name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.asyncUrlEnrichEnabled = try container.decode(Bool.self, forKey: .asyncUrlEnrichEnabled)
        self.autoTranslationEnabled = try container.decode(Bool.self, forKey: .autoTranslationEnabled)
        self.fileUploadConfig = try container.decode(FileUploadConfig.self, forKey: .fileUploadConfig)
        self.imageUploadConfig = try container.decode(FileUploadConfig.self, forKey: .imageUploadConfig)
        self.name = try container.decode(String.self, forKey: .name)
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
