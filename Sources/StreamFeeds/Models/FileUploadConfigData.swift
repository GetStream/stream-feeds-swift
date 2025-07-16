//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FileUploadConfigData: Equatable, Sendable {
    public let allowedFileExtensions: [String]
    public let allowedMimeTypes: [String]
    public let blockedFileExtensions: [String]
    public let blockedMimeTypes: [String]
    public let sizeLimit: Int
}

// MARK: - Model Conversions

extension FileUploadConfig {
    func toModel() -> FileUploadConfigData {
        FileUploadConfigData(
            allowedFileExtensions: allowedFileExtensions,
            allowedMimeTypes: allowedMimeTypes,
            blockedFileExtensions: blockedFileExtensions,
            blockedMimeTypes: blockedMimeTypes,
            sizeLimit: sizeLimit
        )
    }
}
