//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationPayload: Sendable, Encodable, JSONEncodable {
    public let custom: [String: RawJSON]?
    public let images: [String]?
    public let texts: [String]?
    public let videos: [String]?

    public init(custom: [String: RawJSON]? = nil, images: [String]? = nil, texts: [String]? = nil, videos: [String]? = nil) {
        self.custom = custom
        self.images = images
        self.texts = texts
        self.videos = videos
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(texts, forKey: .texts)
        try container.encodeIfPresent(videos, forKey: .videos)
    }
}

extension ModerationPayload: Hashable {
    public static func == (lhs: ModerationPayload, rhs: ModerationPayload) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.images == rhs.images &&
            lhs.texts == rhs.texts &&
            lhs.videos == rhs.videos
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(images)
        hasher.combine(texts)
        hasher.combine(videos)
    }
}
