//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationPayload: Sendable, Codable, JSONEncodable {
    public let audios: [String]?
    public let countryCode: String?
    public let custom: [String: RawJSON]?
    public let imageIds: [String: String]?
    public let imageOrderedKeys: [String]?
    public let images: [String]?
    public let otherMedia: [String]?
    public let textIds: [String: String]?
    public let textOrderedKeys: [String]?
    public let texts: [String]?
    public let videos: [String]?

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.audios = try container.decodeIfPresent([String].self, forKey: .audios)
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(audios, forKey: .audios)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(imageIds, forKey: .imageIds)
        try container.encodeIfPresent(imageOrderedKeys, forKey: .imageOrderedKeys)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(otherMedia, forKey: .otherMedia)
        try container.encodeIfPresent(textIds, forKey: .textIds)
        try container.encodeIfPresent(textOrderedKeys, forKey: .textOrderedKeys)
        try container.encodeIfPresent(texts, forKey: .texts)
        try container.encodeIfPresent(videos, forKey: .videos)
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
