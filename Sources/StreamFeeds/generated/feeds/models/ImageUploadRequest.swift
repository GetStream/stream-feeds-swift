//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageUploadRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var file: String?
    public var uploadSizes: [ImageSize]?
    public var user: OnlyUserID?

    public init(file: String? = nil, uploadSizes: [ImageSize]? = nil, user: OnlyUserID? = nil) {
        self.file = file
        self.uploadSizes = uploadSizes
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case file
        case uploadSizes = "upload_sizes"
        case user
    }

    public static func == (lhs: ImageUploadRequest, rhs: ImageUploadRequest) -> Bool {
        lhs.file == rhs.file &&
            lhs.uploadSizes == rhs.uploadSizes &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(file)
        hasher.combine(uploadSizes)
        hasher.combine(user)
    }
}
