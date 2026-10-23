//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FileUploadConfig: @unchecked Sendable, Codable, JSONEncodable {
    /// The allowed file extensions.
    public var allowedFileExtensions: [String]
    /// The allowed mime types.
    public var allowedMimeTypes: [String]
    /// The blocked file extensions.
    public var blockedFileExtensions: [String]
    /// The blocked mime types.
    public var blockedMimeTypes: [String]
    /// The file size limit allowed in Bytes. 0 means no app-specific limit.
    /// This value is configurable from Stream's Dashboard App Settings.
    public var sizeLimit: Int

    public init(
        allowedFileExtensions: [String],
        allowedMimeTypes: [String],
        blockedFileExtensions: [String],
        blockedMimeTypes: [String],
        sizeLimit: Int
    ) {
        self.allowedFileExtensions = allowedFileExtensions
        self.allowedMimeTypes = allowedMimeTypes
        self.blockedFileExtensions = blockedFileExtensions
        self.blockedMimeTypes = blockedMimeTypes
        self.sizeLimit = sizeLimit
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case allowedFileExtensions = "allowed_file_extensions"
        case allowedMimeTypes = "allowed_mime_types"
        case blockedFileExtensions = "blocked_file_extensions"
        case blockedMimeTypes = "blocked_mime_types"
        case sizeLimit = "size_limit"
    }
}

extension FileUploadConfig: Hashable {
    public static func == (lhs: FileUploadConfig, rhs: FileUploadConfig) -> Bool {
        lhs.allowedFileExtensions == rhs.allowedFileExtensions &&
            lhs.allowedMimeTypes == rhs.allowedMimeTypes &&
            lhs.blockedFileExtensions == rhs.blockedFileExtensions &&
            lhs.blockedMimeTypes == rhs.blockedMimeTypes &&
            lhs.sizeLimit == rhs.sizeLimit
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(allowedFileExtensions)
        hasher.combine(allowedMimeTypes)
        hasher.combine(blockedFileExtensions)
        hasher.combine(blockedMimeTypes)
        hasher.combine(sizeLimit)
    }
}
