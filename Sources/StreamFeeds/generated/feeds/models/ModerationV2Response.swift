//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ModerationV2Response: Sendable, Codable, JSONEncodable {
    public let action: String
    public let blocklistMatched: String?
    public let imageHarms: [String]?
    public let originalText: String
    public let platformCircumvented: Bool?
    public let semanticFilterMatched: String?
    public let textHarms: [String]?

    public init(action: String, blocklistMatched: String? = nil, imageHarms: [String]? = nil, originalText: String, platformCircumvented: Bool? = nil, semanticFilterMatched: String? = nil, textHarms: [String]? = nil) {
        self.action = action
        self.blocklistMatched = blocklistMatched
        self.imageHarms = imageHarms
        self.originalText = originalText
        self.platformCircumvented = platformCircumvented
        self.semanticFilterMatched = semanticFilterMatched
        self.textHarms = textHarms
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(String.self, forKey: .action)
        self.blocklistMatched = try container.decodeIfPresent(String.self, forKey: .blocklistMatched)
        self.imageHarms = try container.decodeIfPresent([String].self, forKey: .imageHarms)
        self.originalText = try container.decode(String.self, forKey: .originalText)
        self.platformCircumvented = try container.decodeIfPresent(Bool.self, forKey: .platformCircumvented)
        self.semanticFilterMatched = try container.decodeIfPresent(String.self, forKey: .semanticFilterMatched)
        self.textHarms = try container.decodeIfPresent([String].self, forKey: .textHarms)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encodeIfPresent(blocklistMatched, forKey: .blocklistMatched)
        try container.encodeIfPresent(imageHarms, forKey: .imageHarms)
        try container.encode(originalText, forKey: .originalText)
        try container.encodeIfPresent(platformCircumvented, forKey: .platformCircumvented)
        try container.encodeIfPresent(semanticFilterMatched, forKey: .semanticFilterMatched)
        try container.encodeIfPresent(textHarms, forKey: .textHarms)
    }
}

extension ModerationV2Response: Hashable {
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
