//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderCondition: Sendable, Encodable, JSONEncodable {
    public let confidence: Double?
    public let contentCountRuleParams: ContentCountRuleParameters?
    public let imageContentParams: ImageContentParameters?
    public let imageRuleParams: ImageRuleParameters?
    public let textContentParams: TextContentParameters?
    public let textRuleParams: TextRuleParameters?
    public let type: String?
    public let userCreatedWithinParams: UserCreatedWithinParameters?
    public let userCustomPropertyParams: UserCustomPropertyParameters?
    public let userRuleParams: UserRuleParameters?
    public let videoContentParams: VideoContentParameters?
    public let videoRuleParams: VideoRuleParameters?

    public init(confidence: Double? = nil, contentCountRuleParams: ContentCountRuleParameters? = nil, imageContentParams: ImageContentParameters? = nil, imageRuleParams: ImageRuleParameters? = nil, textContentParams: TextContentParameters? = nil, textRuleParams: TextRuleParameters? = nil, type: String? = nil, userCreatedWithinParams: UserCreatedWithinParameters? = nil, userCustomPropertyParams: UserCustomPropertyParameters? = nil, userRuleParams: UserRuleParameters? = nil, videoContentParams: VideoContentParameters? = nil, videoRuleParams: VideoRuleParameters? = nil) {
        self.confidence = confidence
        self.contentCountRuleParams = contentCountRuleParams
        self.imageContentParams = imageContentParams
        self.imageRuleParams = imageRuleParams
        self.textContentParams = textContentParams
        self.textRuleParams = textRuleParams
        self.type = type
        self.userCreatedWithinParams = userCreatedWithinParams
        self.userCustomPropertyParams = userCustomPropertyParams
        self.userRuleParams = userRuleParams
        self.videoContentParams = videoContentParams
        self.videoRuleParams = videoRuleParams
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(confidence, forKey: .confidence)
        try container.encodeIfPresent(contentCountRuleParams, forKey: .contentCountRuleParams)
        try container.encodeIfPresent(imageContentParams, forKey: .imageContentParams)
        try container.encodeIfPresent(imageRuleParams, forKey: .imageRuleParams)
        try container.encodeIfPresent(textContentParams, forKey: .textContentParams)
        try container.encodeIfPresent(textRuleParams, forKey: .textRuleParams)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(userCreatedWithinParams, forKey: .userCreatedWithinParams)
        try container.encodeIfPresent(userCustomPropertyParams, forKey: .userCustomPropertyParams)
        try container.encodeIfPresent(userRuleParams, forKey: .userRuleParams)
        try container.encodeIfPresent(videoContentParams, forKey: .videoContentParams)
        try container.encodeIfPresent(videoRuleParams, forKey: .videoRuleParams)
    }
}

extension RuleBuilderCondition: Hashable {
    public static func == (lhs: RuleBuilderCondition, rhs: RuleBuilderCondition) -> Bool {
        lhs.confidence == rhs.confidence &&
            lhs.contentCountRuleParams == rhs.contentCountRuleParams &&
            lhs.imageContentParams == rhs.imageContentParams &&
            lhs.imageRuleParams == rhs.imageRuleParams &&
            lhs.textContentParams == rhs.textContentParams &&
            lhs.textRuleParams == rhs.textRuleParams &&
            lhs.type == rhs.type &&
            lhs.userCreatedWithinParams == rhs.userCreatedWithinParams &&
            lhs.userCustomPropertyParams == rhs.userCustomPropertyParams &&
            lhs.userRuleParams == rhs.userRuleParams &&
            lhs.videoContentParams == rhs.videoContentParams &&
            lhs.videoRuleParams == rhs.videoRuleParams
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(confidence)
        hasher.combine(contentCountRuleParams)
        hasher.combine(imageContentParams)
        hasher.combine(imageRuleParams)
        hasher.combine(textContentParams)
        hasher.combine(textRuleParams)
        hasher.combine(type)
        hasher.combine(userCreatedWithinParams)
        hasher.combine(userCustomPropertyParams)
        hasher.combine(userRuleParams)
        hasher.combine(videoContentParams)
        hasher.combine(videoRuleParams)
    }
}
