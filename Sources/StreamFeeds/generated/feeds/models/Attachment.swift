//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// An attachment is a message object that represents a file uploaded by a user.
public final class Attachment: Sendable, Codable, JSONEncodable {
    public let actions: [Action]?
    public let assetUrl: String?
    public let authorIcon: String?
    public let authorLink: String?
    public let authorName: String?
    public let color: String?
    public let custom: [String: RawJSON]
    public let fallback: String?
    public let fields: [Field]?
    public let footer: String?
    public let footerIcon: String?
    public let giphy: Images?
    public let imageUrl: String?
    public let ogScrapeUrl: String?
    public let originalHeight: Int?
    public let originalWidth: Int?
    public let pretext: String?
    public let text: String?
    public let thumbUrl: String?
    public let title: String?
    public let titleLink: String?
    /// Attachment type (e.g. image, video, url)
    public let type: String?

    public init(actions: [Action]? = nil, assetUrl: String? = nil, authorIcon: String? = nil, authorLink: String? = nil, authorName: String? = nil, color: String? = nil, custom: [String: RawJSON], fallback: String? = nil, fields: [Field]? = nil, footer: String? = nil, footerIcon: String? = nil, giphy: Images? = nil, imageUrl: String? = nil, ogScrapeUrl: String? = nil, originalHeight: Int? = nil, originalWidth: Int? = nil, pretext: String? = nil, text: String? = nil, thumbUrl: String? = nil, title: String? = nil, titleLink: String? = nil, type: String? = nil) {
        self.actions = actions
        self.assetUrl = assetUrl
        self.authorIcon = authorIcon
        self.authorLink = authorLink
        self.authorName = authorName
        self.color = color
        self.custom = custom
        self.fallback = fallback
        self.fields = fields
        self.footer = footer
        self.footerIcon = footerIcon
        self.giphy = giphy
        self.imageUrl = imageUrl
        self.ogScrapeUrl = ogScrapeUrl
        self.originalHeight = originalHeight
        self.originalWidth = originalWidth
        self.pretext = pretext
        self.text = text
        self.thumbUrl = thumbUrl
        self.title = title
        self.titleLink = titleLink
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.actions = try container.decodeIfPresent([Action].self, forKey: .actions)
        self.assetUrl = try container.decodeIfPresent(String.self, forKey: .assetUrl)
        self.authorIcon = try container.decodeIfPresent(String.self, forKey: .authorIcon)
        self.authorLink = try container.decodeIfPresent(String.self, forKey: .authorLink)
        self.authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.fallback = try container.decodeIfPresent(String.self, forKey: .fallback)
        self.fields = try container.decodeIfPresent([Field].self, forKey: .fields)
        self.footer = try container.decodeIfPresent(String.self, forKey: .footer)
        self.footerIcon = try container.decodeIfPresent(String.self, forKey: .footerIcon)
        self.giphy = try container.decodeIfPresent(Images.self, forKey: .giphy)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.ogScrapeUrl = try container.decodeIfPresent(String.self, forKey: .ogScrapeUrl)
        self.originalHeight = try container.decodeIfPresent(Int.self, forKey: .originalHeight)
        self.originalWidth = try container.decodeIfPresent(Int.self, forKey: .originalWidth)
        self.pretext = try container.decodeIfPresent(String.self, forKey: .pretext)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.thumbUrl = try container.decodeIfPresent(String.self, forKey: .thumbUrl)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.titleLink = try container.decodeIfPresent(String.self, forKey: .titleLink)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(actions, forKey: .actions)
        try container.encodeIfPresent(assetUrl, forKey: .assetUrl)
        try container.encodeIfPresent(authorIcon, forKey: .authorIcon)
        try container.encodeIfPresent(authorLink, forKey: .authorLink)
        try container.encodeIfPresent(authorName, forKey: .authorName)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(fallback, forKey: .fallback)
        try container.encodeIfPresent(fields, forKey: .fields)
        try container.encodeIfPresent(footer, forKey: .footer)
        try container.encodeIfPresent(footerIcon, forKey: .footerIcon)
        try container.encodeIfPresent(giphy, forKey: .giphy)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(ogScrapeUrl, forKey: .ogScrapeUrl)
        try container.encodeIfPresent(originalHeight, forKey: .originalHeight)
        try container.encodeIfPresent(originalWidth, forKey: .originalWidth)
        try container.encodeIfPresent(pretext, forKey: .pretext)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(thumbUrl, forKey: .thumbUrl)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(titleLink, forKey: .titleLink)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

extension Attachment: Hashable {
    public static func == (lhs: Attachment, rhs: Attachment) -> Bool {
        lhs.actions == rhs.actions &&
            lhs.assetUrl == rhs.assetUrl &&
            lhs.authorIcon == rhs.authorIcon &&
            lhs.authorLink == rhs.authorLink &&
            lhs.authorName == rhs.authorName &&
            lhs.color == rhs.color &&
            lhs.custom == rhs.custom &&
            lhs.fallback == rhs.fallback &&
            lhs.fields == rhs.fields &&
            lhs.footer == rhs.footer &&
            lhs.footerIcon == rhs.footerIcon &&
            lhs.giphy == rhs.giphy &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.ogScrapeUrl == rhs.ogScrapeUrl &&
            lhs.originalHeight == rhs.originalHeight &&
            lhs.originalWidth == rhs.originalWidth &&
            lhs.pretext == rhs.pretext &&
            lhs.text == rhs.text &&
            lhs.thumbUrl == rhs.thumbUrl &&
            lhs.title == rhs.title &&
            lhs.titleLink == rhs.titleLink &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(actions)
        hasher.combine(assetUrl)
        hasher.combine(authorIcon)
        hasher.combine(authorLink)
        hasher.combine(authorName)
        hasher.combine(color)
        hasher.combine(custom)
        hasher.combine(fallback)
        hasher.combine(fields)
        hasher.combine(footer)
        hasher.combine(footerIcon)
        hasher.combine(giphy)
        hasher.combine(imageUrl)
        hasher.combine(ogScrapeUrl)
        hasher.combine(originalHeight)
        hasher.combine(originalWidth)
        hasher.combine(pretext)
        hasher.combine(text)
        hasher.combine(thumbUrl)
        hasher.combine(title)
        hasher.combine(titleLink)
        hasher.combine(type)
    }
}
