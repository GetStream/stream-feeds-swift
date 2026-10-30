//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Content payload for moderation
public final class ModerationPayloadResponse: Sendable, Decodable {
    /// Audio URLs to moderate
    public let audios: [String]?
    /// Custom data for moderation
    public let custom: [String: RawJSON]?
    /// Caller-supplied content IDs per image key (from content_ids on /analyze)
    public let imageIds: [String: String]?
    /// Caller-supplied keys for images, index-aligned with images[]
    public let imageOrderedKeys: [String]?
    /// Image URLs to moderate
    public let images: [String]?
    /// Media URLs from attachments outside the typed image/video/audio lists (custom attachment types such as GIF pickers)
    public let otherMedia: [String]?
    /// Caller-supplied content IDs per text key (from content_ids on /analyze)
    public let textIds: [String: String]?
    /// Caller-supplied keys for texts (e.g. "title", "description"), index-aligned with texts[]
    public let textOrderedKeys: [String]?
    /// Text content to moderate
    public let texts: [String]?
    /// Video URLs to moderate
    public let videos: [String]?

    public init(audios: [String]? = nil, custom: [String: RawJSON]? = nil, imageIds: [String: String]? = nil, imageOrderedKeys: [String]? = nil, images: [String]? = nil, otherMedia: [String]? = nil, textIds: [String: String]? = nil, textOrderedKeys: [String]? = nil, texts: [String]? = nil, videos: [String]? = nil) {
        self.audios = audios
        self.custom = custom
        self.imageIds = imageIds
        self.imageOrderedKeys = imageOrderedKeys
        self.images = images
        self.otherMedia = otherMedia
        self.textIds = textIds
        self.textOrderedKeys = textOrderedKeys
        self.texts = texts
        self.videos = videos
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.audios = try container.decodeIfPresent([String].self, forKey: .audios)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.imageIds = try container.decodeIfPresent([String: String].self, forKey: .imageIds)
        self.imageOrderedKeys = try container.decodeIfPresent([String].self, forKey: .imageOrderedKeys)
        self.images = try container.decodeIfPresent([String].self, forKey: .images)
        self.otherMedia = try container.decodeIfPresent([String].self, forKey: .otherMedia)
        self.textIds = try container.decodeIfPresent([String: String].self, forKey: .textIds)
        self.textOrderedKeys = try container.decodeIfPresent([String].self, forKey: .textOrderedKeys)
        self.texts = try container.decodeIfPresent([String].self, forKey: .texts)
        self.videos = try container.decodeIfPresent([String].self, forKey: .videos)
    }
}

extension ModerationPayloadResponse: Hashable {
    public static func == (lhs: ModerationPayloadResponse, rhs: ModerationPayloadResponse) -> Bool {
        lhs.audios == rhs.audios &&
            lhs.custom == rhs.custom &&
            lhs.imageIds == rhs.imageIds &&
            lhs.imageOrderedKeys == rhs.imageOrderedKeys &&
            lhs.images == rhs.images &&
            lhs.otherMedia == rhs.otherMedia &&
            lhs.textIds == rhs.textIds &&
            lhs.textOrderedKeys == rhs.textOrderedKeys &&
            lhs.texts == rhs.texts &&
            lhs.videos == rhs.videos
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(audios)
        hasher.combine(custom)
        hasher.combine(imageIds)
        hasher.combine(imageOrderedKeys)
        hasher.combine(images)
        hasher.combine(otherMedia)
        hasher.combine(textIds)
        hasher.combine(textOrderedKeys)
        hasher.combine(texts)
        hasher.combine(videos)
    }
}
