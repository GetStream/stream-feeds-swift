//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageSize: @unchecked Sendable, Codable, JSONEncodable {
    /// Crop mode. One of: top, bottom, left, right, center
    public var crop: String?
    /// Target image height
    public var height: Int?
    /// Resize method. One of: clip, crop, scale, fill
    public var resize: String?
    /// Target image width
    public var width: Int?

    public init(crop: String? = nil, height: Int? = nil, resize: String? = nil, width: Int? = nil) {
        self.crop = crop
        self.height = height
        self.resize = resize
        self.width = width
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case crop
        case height
        case resize
        case width
    }
}

extension ImageSize: Hashable {
    public static func == (lhs: ImageSize, rhs: ImageSize) -> Bool {
        lhs.crop == rhs.crop &&
            lhs.height == rhs.height &&
            lhs.resize == rhs.resize &&
            lhs.width == rhs.width
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(crop)
        hasher.combine(height)
        hasher.combine(resize)
        hasher.combine(width)
    }
}
