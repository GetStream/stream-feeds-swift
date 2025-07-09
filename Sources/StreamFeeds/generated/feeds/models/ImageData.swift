//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageData: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var frames: String
    public var height: String
    public var size: String
    public var url: String
    public var width: String

    public init(frames: String, height: String, size: String, url: String, width: String) {
        self.frames = frames
        self.height = height
        self.size = size
        self.url = url
        self.width = width
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case frames
        case height
        case size
        case url
        case width
    }

    public static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        lhs.frames == rhs.frames &&
            lhs.height == rhs.height &&
            lhs.size == rhs.size &&
            lhs.url == rhs.url &&
            lhs.width == rhs.width
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(frames)
        hasher.combine(height)
        hasher.combine(size)
        hasher.combine(url)
        hasher.combine(width)
    }
}
