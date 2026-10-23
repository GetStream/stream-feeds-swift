//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageUploadResponse: Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public let duration: String
    public let file: String?
    public let thumbUrl: String?
    /// Array of image size configurations
    public let uploadSizes: [ImageSize]?

    public init(duration: String, file: String? = nil, thumbUrl: String? = nil, uploadSizes: [ImageSize]? = nil) {
        self.duration = duration
        self.file = file
        self.thumbUrl = thumbUrl
        self.uploadSizes = uploadSizes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.file = try container.decodeIfPresent(String.self, forKey: .file)
        self.thumbUrl = try container.decodeIfPresent(String.self, forKey: .thumbUrl)
        self.uploadSizes = try container.decodeIfPresent([ImageSize].self, forKey: .uploadSizes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(file, forKey: .file)
        try container.encodeIfPresent(thumbUrl, forKey: .thumbUrl)
        try container.encodeIfPresent(uploadSizes, forKey: .uploadSizes)
    }
}

extension ImageUploadResponse: Hashable {
    public static func == (lhs: ImageUploadResponse, rhs: ImageUploadResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.file == rhs.file &&
            lhs.thumbUrl == rhs.thumbUrl &&
            lhs.uploadSizes == rhs.uploadSizes
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(file)
        hasher.combine(thumbUrl)
        hasher.combine(uploadSizes)
    }
}
