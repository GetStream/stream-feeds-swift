//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageData: Sendable, Codable, JSONEncodable {
    public let frames: String
    public let height: String
    public let size: String
    public let url: String
    public let width: String

    public init(frames: String, height: String, size: String, url: String, width: String) {
        self.frames = frames
        self.height = height
        self.size = size
        self.url = url
        self.width = width
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.frames = try container.decode(String.self, forKey: .frames)
        self.height = try container.decode(String.self, forKey: .height)
        self.size = try container.decode(String.self, forKey: .size)
        self.url = try container.decode(String.self, forKey: .url)
        self.width = try container.decode(String.self, forKey: .width)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(frames, forKey: .frames)
        try container.encode(height, forKey: .height)
        try container.encode(size, forKey: .size)
        try container.encode(url, forKey: .url)
        try container.encode(width, forKey: .width)
    }
}

extension ImageData: Hashable {
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
