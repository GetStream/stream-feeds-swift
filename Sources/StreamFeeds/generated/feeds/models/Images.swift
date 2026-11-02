//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Images: Sendable, Codable, JSONEncodable {
    public let fixedHeight: ImageData
    public let fixedHeightDownsampled: ImageData
    public let fixedHeightStill: ImageData
    public let fixedWidth: ImageData
    public let fixedWidthDownsampled: ImageData
    public let fixedWidthStill: ImageData
    public let original: ImageData

    public init(fixedHeight: ImageData, fixedHeightDownsampled: ImageData, fixedHeightStill: ImageData, fixedWidth: ImageData, fixedWidthDownsampled: ImageData, fixedWidthStill: ImageData, original: ImageData) {
        self.fixedHeight = fixedHeight
        self.fixedHeightDownsampled = fixedHeightDownsampled
        self.fixedHeightStill = fixedHeightStill
        self.fixedWidth = fixedWidth
        self.fixedWidthDownsampled = fixedWidthDownsampled
        self.fixedWidthStill = fixedWidthStill
        self.original = original
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.fixedHeight = try container.decode(ImageData.self, forKey: .fixedHeight)
        self.fixedHeightDownsampled = try container.decode(ImageData.self, forKey: .fixedHeightDownsampled)
        self.fixedHeightStill = try container.decode(ImageData.self, forKey: .fixedHeightStill)
        self.fixedWidth = try container.decode(ImageData.self, forKey: .fixedWidth)
        self.fixedWidthDownsampled = try container.decode(ImageData.self, forKey: .fixedWidthDownsampled)
        self.fixedWidthStill = try container.decode(ImageData.self, forKey: .fixedWidthStill)
        self.original = try container.decode(ImageData.self, forKey: .original)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(fixedHeight, forKey: .fixedHeight)
        try container.encode(fixedHeightDownsampled, forKey: .fixedHeightDownsampled)
        try container.encode(fixedHeightStill, forKey: .fixedHeightStill)
        try container.encode(fixedWidth, forKey: .fixedWidth)
        try container.encode(fixedWidthDownsampled, forKey: .fixedWidthDownsampled)
        try container.encode(fixedWidthStill, forKey: .fixedWidthStill)
        try container.encode(original, forKey: .original)
    }
}

extension Images: Hashable {
    public static func == (lhs: Images, rhs: Images) -> Bool {
        lhs.fixedHeight == rhs.fixedHeight &&
            lhs.fixedHeightDownsampled == rhs.fixedHeightDownsampled &&
            lhs.fixedHeightStill == rhs.fixedHeightStill &&
            lhs.fixedWidth == rhs.fixedWidth &&
            lhs.fixedWidthDownsampled == rhs.fixedWidthDownsampled &&
            lhs.fixedWidthStill == rhs.fixedWidthStill &&
            lhs.original == rhs.original
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(fixedHeight)
        hasher.combine(fixedHeightDownsampled)
        hasher.combine(fixedHeightStill)
        hasher.combine(fixedWidth)
        hasher.combine(fixedWidthDownsampled)
        hasher.combine(fixedWidthStill)
        hasher.combine(original)
    }
}
