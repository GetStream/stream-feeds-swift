//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationV2Response: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var action: String
    public var blocklistMatched: String?
    public var imageHarms: [String]?
    public var originalText: String
    public var platformCircumvented: Bool?
    public var semanticFilterMatched: String?
    public var textHarms: [String]?

    public init(action: String, blocklistMatched: String? = nil, imageHarms: [String]? = nil, originalText: String, platformCircumvented: Bool? = nil, semanticFilterMatched: String? = nil, textHarms: [String]? = nil) {
        self.action = action
        self.blocklistMatched = blocklistMatched
        self.imageHarms = imageHarms
        self.originalText = originalText
        self.platformCircumvented = platformCircumvented
        self.semanticFilterMatched = semanticFilterMatched
        self.textHarms = textHarms
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case blocklistMatched = "blocklist_matched"
        case imageHarms = "image_harms"
        case originalText = "original_text"
        case platformCircumvented = "platform_circumvented"
        case semanticFilterMatched = "semantic_filter_matched"
        case textHarms = "text_harms"
    }

    public static func == (lhs: ModerationV2Response, rhs: ModerationV2Response) -> Bool {
        lhs.action == rhs.action &&
            lhs.blocklistMatched == rhs.blocklistMatched &&
            lhs.imageHarms == rhs.imageHarms &&
            lhs.originalText == rhs.originalText &&
            lhs.platformCircumvented == rhs.platformCircumvented &&
            lhs.semanticFilterMatched == rhs.semanticFilterMatched &&
            lhs.textHarms == rhs.textHarms
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(blocklistMatched)
        hasher.combine(imageHarms)
        hasher.combine(originalText)
        hasher.combine(platformCircumvented)
        hasher.combine(semanticFilterMatched)
        hasher.combine(textHarms)
    }
}
