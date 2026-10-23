//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FileUploadResponse: Sendable, Decodable {
    /// Duration of the request in milliseconds
    public let duration: String
    /// URL to the uploaded asset. Should be used to put to `asset_url` attachment field
    public let file: String?
    /// URL of the file thumbnail for supported file formats. Should be put to `thumb_url` attachment field
    public let thumbUrl: String?

    public init(duration: String, file: String? = nil, thumbUrl: String? = nil) {
        self.duration = duration
        self.file = file
        self.thumbUrl = thumbUrl
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.file = try container.decodeIfPresent(String.self, forKey: .file)
        self.thumbUrl = try container.decodeIfPresent(String.self, forKey: .thumbUrl)
    }
}

extension FileUploadResponse: Hashable {
    public static func == (lhs: FileUploadResponse, rhs: FileUploadResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.file == rhs.file &&
            lhs.thumbUrl == rhs.thumbUrl
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(file)
        hasher.combine(thumbUrl)
    }
}
