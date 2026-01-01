//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageUploadResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var file: String?
    public var thumbUrl: String?
    public var uploadSizes: [ImageSize]?

    public init(duration: String, file: String? = nil, thumbUrl: String? = nil, uploadSizes: [ImageSize]? = nil) {
        self.duration = duration
        self.file = file
        self.thumbUrl = thumbUrl
        self.uploadSizes = uploadSizes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case file
        case thumbUrl = "thumb_url"
        case uploadSizes = "upload_sizes"
    }

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
