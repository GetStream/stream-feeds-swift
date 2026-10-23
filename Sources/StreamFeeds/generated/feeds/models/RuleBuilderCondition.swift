//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderCondition: Sendable, Codable, JSONEncodable {
    public let confidence: Double?
    public let contentCountRuleParams: ContentCountRuleParameters?
    public let contentCountryCodeParams: ContentCountryCodeParameters?
    public let contentCustomPropertyCountParams: ContentCustomPropertyCountParameters?
    public let contentCustomPropertyParams: ContentCustomPropertyParameters?
    public let contentFlagCountRuleParams: FlagCountRuleParameters?
    public let floodIdenticalParams: FloodIdenticalRuleParameters?
    public let floodSimilarParams: FloodSimilarRuleParameters?
    public let imageContentParams: ImageContentParameters?
    public let imageRuleParams: ImageRuleParameters?
    /// intent_rule params: policy intent topic label and the minimum final score (1-100) that fires the condition
    public let intentRuleParams: IntentRuleParameters?
    public let ipContentCountRuleParams: IPContentCountRuleParameters?
    public let ipFlagCountRuleParams: IPFlagCountRuleParameters?
    public let ocrContentParams: OCRContentParameters?
    public let textContentParams: TextContentParameters?
    public let textRuleParams: TextRuleParameters?
    public let type: String?
    public let userCreatedWithinParams: UserCreatedWithinParameters?
    public let userCustomPropertyParams: UserCustomPropertyParameters?
    public let userFlagCountRuleParams: FlagCountRuleParameters?
    public let userIdenticalContentCountParams: UserIdenticalContentCountParameters?
    public let userIdenticalImageCountParams: UserIdenticalImageCountParameters?
    public let userReactionCountParams: UserReactionCountRuleParameters?
    public let userRoleParams: UserRoleParameters?
    public let userRuleParams: UserRuleParameters?
    public let videoContentParams: VideoContentParameters?
    public let videoRuleParams: VideoRuleParameters?

    public init(confidence: Double? = nil, contentCountRuleParams: ContentCountRuleParameters? = nil, contentCountryCodeParams: ContentCountryCodeParameters? = nil, contentCustomPropertyCountParams: ContentCustomPropertyCountParameters? = nil, contentCustomPropertyParams: ContentCustomPropertyParameters? = nil, contentFlagCountRuleParams: FlagCountRuleParameters? = nil, floodIdenticalParams: FloodIdenticalRuleParameters? = nil, floodSimilarParams: FloodSimilarRuleParameters? = nil, imageContentParams: ImageContentParameters? = nil, imageRuleParams: ImageRuleParameters? = nil, intentRuleParams: IntentRuleParameters? = nil, ipContentCountRuleParams: IPContentCountRuleParameters? = nil, ipFlagCountRuleParams: IPFlagCountRuleParameters? = nil, ocrContentParams: OCRContentParameters? = nil, textContentParams: TextContentParameters? = nil, textRuleParams: TextRuleParameters? = nil, type: String? = nil, userCreatedWithinParams: UserCreatedWithinParameters? = nil, userCustomPropertyParams: UserCustomPropertyParameters? = nil, userFlagCountRuleParams: FlagCountRuleParameters? = nil, userIdenticalContentCountParams: UserIdenticalContentCountParameters? = nil, userIdenticalImageCountParams: UserIdenticalImageCountParameters? = nil, userReactionCountParams: UserReactionCountRuleParameters? = nil, userRoleParams: UserRoleParameters? = nil, userRuleParams: UserRuleParameters? = nil, videoContentParams: VideoContentParameters? = nil, videoRuleParams: VideoRuleParameters? = nil) {
        self.confidence = confidence
        self.contentCountRuleParams = contentCountRuleParams
        self.contentCountryCodeParams = contentCountryCodeParams
        self.contentCustomPropertyCountParams = contentCustomPropertyCountParams
        self.contentCustomPropertyParams = contentCustomPropertyParams
        self.contentFlagCountRuleParams = contentFlagCountRuleParams
        self.floodIdenticalParams = floodIdenticalParams
        self.floodSimilarParams = floodSimilarParams
        self.imageContentParams = imageContentParams
        self.imageRuleParams = imageRuleParams
        self.intentRuleParams = intentRuleParams
        self.ipContentCountRuleParams = ipContentCountRuleParams
        self.ipFlagCountRuleParams = ipFlagCountRuleParams
        self.ocrContentParams = ocrContentParams
        self.textContentParams = textContentParams
        self.textRuleParams = textRuleParams
        self.type = type
        self.userCreatedWithinParams = userCreatedWithinParams
        self.userCustomPropertyParams = userCustomPropertyParams
        self.userFlagCountRuleParams = userFlagCountRuleParams
        self.userIdenticalContentCountParams = userIdenticalContentCountParams
        self.userIdenticalImageCountParams = userIdenticalImageCountParams
        self.userReactionCountParams = userReactionCountParams
        self.userRoleParams = userRoleParams
        self.userRuleParams = userRuleParams
        self.videoContentParams = videoContentParams
        self.videoRuleParams = videoRuleParams
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.confidence = try container.decodeIfPresent(Double.self, forKey: .confidence)
        self.contentCountRuleParams = try container.decodeIfPresent(ContentCountRuleParameters.self, forKey: .contentCountRuleParams)
        self.contentCountryCodeParams = try container.decodeIfPresent(ContentCountryCodeParameters.self, forKey: .contentCountryCodeParams)
        self.contentCustomPropertyCountParams = try container.decodeIfPresent(ContentCustomPropertyCountParameters.self, forKey: .contentCustomPropertyCountParams)
        self.contentCustomPropertyParams = try container.decodeIfPresent(ContentCustomPropertyParameters.self, forKey: .contentCustomPropertyParams)
        self.contentFlagCountRuleParams = try container.decodeIfPresent(FlagCountRuleParameters.self, forKey: .contentFlagCountRuleParams)
        self.floodIdenticalParams = try container.decodeIfPresent(FloodIdenticalRuleParameters.self, forKey: .floodIdenticalParams)
        self.floodSimilarParams = try container.decodeIfPresent(FloodSimilarRuleParameters.self, forKey: .floodSimilarParams)
        self.imageContentParams = try container.decodeIfPresent(ImageContentParameters.self, forKey: .imageContentParams)
        self.imageRuleParams = try container.decodeIfPresent(ImageRuleParameters.self, forKey: .imageRuleParams)
        self.intentRuleParams = try container.decodeIfPresent(IntentRuleParameters.self, forKey: .intentRuleParams)
        self.ipContentCountRuleParams = try container.decodeIfPresent(IPContentCountRuleParameters.self, forKey: .ipContentCountRuleParams)
        self.ipFlagCountRuleParams = try container.decodeIfPresent(IPFlagCountRuleParameters.self, forKey: .ipFlagCountRuleParams)
        self.ocrContentParams = try container.decodeIfPresent(OCRContentParameters.self, forKey: .ocrContentParams)
        self.textContentParams = try container.decodeIfPresent(TextContentParameters.self, forKey: .textContentParams)
        self.textRuleParams = try container.decodeIfPresent(TextRuleParameters.self, forKey: .textRuleParams)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.userCreatedWithinParams = try container.decodeIfPresent(UserCreatedWithinParameters.self, forKey: .userCreatedWithinParams)
        self.userCustomPropertyParams = try container.decodeIfPresent(UserCustomPropertyParameters.self, forKey: .userCustomPropertyParams)
        self.userFlagCountRuleParams = try container.decodeIfPresent(FlagCountRuleParameters.self, forKey: .userFlagCountRuleParams)
        self.userIdenticalContentCountParams = try container.decodeIfPresent(UserIdenticalContentCountParameters.self, forKey: .userIdenticalContentCountParams)
        self.userIdenticalImageCountParams = try container.decodeIfPresent(UserIdenticalImageCountParameters.self, forKey: .userIdenticalImageCountParams)
        self.userReactionCountParams = try container.decodeIfPresent(UserReactionCountRuleParameters.self, forKey: .userReactionCountParams)
        self.userRoleParams = try container.decodeIfPresent(UserRoleParameters.self, forKey: .userRoleParams)
        self.userRuleParams = try container.decodeIfPresent(UserRuleParameters.self, forKey: .userRuleParams)
        self.videoContentParams = try container.decodeIfPresent(VideoContentParameters.self, forKey: .videoContentParams)
        self.videoRuleParams = try container.decodeIfPresent(VideoRuleParameters.self, forKey: .videoRuleParams)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(confidence, forKey: .confidence)
        try container.encodeIfPresent(contentCountRuleParams, forKey: .contentCountRuleParams)
        try container.encodeIfPresent(contentCountryCodeParams, forKey: .contentCountryCodeParams)
        try container.encodeIfPresent(contentCustomPropertyCountParams, forKey: .contentCustomPropertyCountParams)
        try container.encodeIfPresent(contentCustomPropertyParams, forKey: .contentCustomPropertyParams)
        try container.encodeIfPresent(contentFlagCountRuleParams, forKey: .contentFlagCountRuleParams)
        try container.encodeIfPresent(floodIdenticalParams, forKey: .floodIdenticalParams)
        try container.encodeIfPresent(floodSimilarParams, forKey: .floodSimilarParams)
        try container.encodeIfPresent(imageContentParams, forKey: .imageContentParams)
        try container.encodeIfPresent(imageRuleParams, forKey: .imageRuleParams)
        try container.encodeIfPresent(intentRuleParams, forKey: .intentRuleParams)
        try container.encodeIfPresent(ipContentCountRuleParams, forKey: .ipContentCountRuleParams)
        try container.encodeIfPresent(ipFlagCountRuleParams, forKey: .ipFlagCountRuleParams)
        try container.encodeIfPresent(ocrContentParams, forKey: .ocrContentParams)
        try container.encodeIfPresent(textContentParams, forKey: .textContentParams)
        try container.encodeIfPresent(textRuleParams, forKey: .textRuleParams)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(userCreatedWithinParams, forKey: .userCreatedWithinParams)
        try container.encodeIfPresent(userCustomPropertyParams, forKey: .userCustomPropertyParams)
        try container.encodeIfPresent(userFlagCountRuleParams, forKey: .userFlagCountRuleParams)
        try container.encodeIfPresent(userIdenticalContentCountParams, forKey: .userIdenticalContentCountParams)
        try container.encodeIfPresent(userIdenticalImageCountParams, forKey: .userIdenticalImageCountParams)
        try container.encodeIfPresent(userReactionCountParams, forKey: .userReactionCountParams)
        try container.encodeIfPresent(userRoleParams, forKey: .userRoleParams)
        try container.encodeIfPresent(userRuleParams, forKey: .userRuleParams)
        try container.encodeIfPresent(videoContentParams, forKey: .videoContentParams)
        try container.encodeIfPresent(videoRuleParams, forKey: .videoRuleParams)
    }
}

extension RuleBuilderCondition: Hashable {
    public static func == (lhs: RuleBuilderCondition, rhs: RuleBuilderCondition) -> Bool {
        lhs.confidence == rhs.confidence &&
            lhs.contentCountRuleParams == rhs.contentCountRuleParams &&
            lhs.contentCountryCodeParams == rhs.contentCountryCodeParams &&
            lhs.contentCustomPropertyCountParams == rhs.contentCustomPropertyCountParams &&
            lhs.contentCustomPropertyParams == rhs.contentCustomPropertyParams &&
            lhs.contentFlagCountRuleParams == rhs.contentFlagCountRuleParams &&
            lhs.floodIdenticalParams == rhs.floodIdenticalParams &&
            lhs.floodSimilarParams == rhs.floodSimilarParams &&
            lhs.imageContentParams == rhs.imageContentParams &&
            lhs.imageRuleParams == rhs.imageRuleParams &&
            lhs.intentRuleParams == rhs.intentRuleParams &&
            lhs.ipContentCountRuleParams == rhs.ipContentCountRuleParams &&
            lhs.ipFlagCountRuleParams == rhs.ipFlagCountRuleParams &&
            lhs.ocrContentParams == rhs.ocrContentParams &&
            lhs.textContentParams == rhs.textContentParams &&
            lhs.textRuleParams == rhs.textRuleParams &&
            lhs.type == rhs.type &&
            lhs.userCreatedWithinParams == rhs.userCreatedWithinParams &&
            lhs.userCustomPropertyParams == rhs.userCustomPropertyParams &&
            lhs.userFlagCountRuleParams == rhs.userFlagCountRuleParams &&
            lhs.userIdenticalContentCountParams == rhs.userIdenticalContentCountParams &&
            lhs.userIdenticalImageCountParams == rhs.userIdenticalImageCountParams &&
            lhs.userReactionCountParams == rhs.userReactionCountParams &&
            lhs.userRoleParams == rhs.userRoleParams &&
            lhs.userRuleParams == rhs.userRuleParams &&
            lhs.videoContentParams == rhs.videoContentParams &&
            lhs.videoRuleParams == rhs.videoRuleParams
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(confidence)
        hasher.combine(contentCountRuleParams)
        hasher.combine(contentCountryCodeParams)
        hasher.combine(contentCustomPropertyCountParams)
        hasher.combine(contentCustomPropertyParams)
        hasher.combine(contentFlagCountRuleParams)
        hasher.combine(floodIdenticalParams)
        hasher.combine(floodSimilarParams)
        hasher.combine(imageContentParams)
        hasher.combine(imageRuleParams)
        hasher.combine(intentRuleParams)
        hasher.combine(ipContentCountRuleParams)
        hasher.combine(ipFlagCountRuleParams)
        hasher.combine(ocrContentParams)
        hasher.combine(textContentParams)
        hasher.combine(textRuleParams)
        hasher.combine(type)
        hasher.combine(userCreatedWithinParams)
        hasher.combine(userCustomPropertyParams)
        hasher.combine(userFlagCountRuleParams)
        hasher.combine(userIdenticalContentCountParams)
        hasher.combine(userIdenticalImageCountParams)
        hasher.combine(userReactionCountParams)
        hasher.combine(userRoleParams)
        hasher.combine(userRuleParams)
        hasher.combine(videoContentParams)
        hasher.combine(videoRuleParams)
    }
}
