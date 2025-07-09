//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FileUploadResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var file: String?
    public var thumbUrl: String?

    public init(duration: String, file: String? = nil, thumbUrl: String? = nil) {
        self.duration = duration
        self.file = file
        self.thumbUrl = thumbUrl
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case file
        case thumbUrl = "thumb_url"
    }

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
