//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationPayload: @unchecked Sendable, Codable, JSONEncodable {
    public var audios: [String]?
    public var countryCode: String?
    public var custom: [String: RawJSON]?
    public var imageIds: [String: String]?
    public var imageOrderedKeys: [String]?
    public var images: [String]?
    public var otherMedia: [String]?
    public var textIds: [String: String]?
    public var textOrderedKeys: [String]?
    public var texts: [String]?
    public var videos: [String]?

    public init(audios: [String]? = nil, countryCode: String? = nil, custom: [String: RawJSON]? = nil, imageIds: [String: String]? = nil, imageOrderedKeys: [String]? = nil, images: [String]? = nil, otherMedia: [String]? = nil, textIds: [String: String]? = nil, textOrderedKeys: [String]? = nil, texts: [String]? = nil, videos: [String]? = nil) {
        self.audios = audios
        self.countryCode = countryCode
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
        case countryCode = "country_code"
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

extension ModerationPayload: Hashable {
    public static func == (lhs: ModerationPayload, rhs: ModerationPayload) -> Bool {
        lhs.audios == rhs.audios &&
            lhs.countryCode == rhs.countryCode &&
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
        hasher.combine(countryCode)
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
