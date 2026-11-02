//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Content payload for moderation
public final class ModerationPayloadResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Audio URLs to moderate
    public var audios: [String]?
    /// Custom data for moderation
    public var custom: [String: RawJSON]?
    /// Caller-supplied content IDs per image key (from content_ids on /analyze)
    public var imageIds: [String: String]?
    /// Caller-supplied keys for images, index-aligned with images[]
    public var imageOrderedKeys: [String]?
    /// Image URLs to moderate
    public var images: [String]?
    /// Media URLs from attachments outside the typed image/video/audio lists (custom attachment types such as GIF pickers)
    public var otherMedia: [String]?
    /// Caller-supplied content IDs per text key (from content_ids on /analyze)
    public var textIds: [String: String]?
    /// Caller-supplied keys for texts (e.g. "title", "description"), index-aligned with texts[]
    public var textOrderedKeys: [String]?
    /// Text content to moderate
    public var texts: [String]?
    /// Video URLs to moderate
    public var videos: [String]?

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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case audios
        case custom
        case imageIds = "image_ids"
        case imageOrderedKeys = "image_ordered_keys"
        case images
        case otherMedia = "other_media"
        case textIds = "text_ids"
        case textOrderedKeys = "text_ordered_keys"
        case texts
        case videos
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
