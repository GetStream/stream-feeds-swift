//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderCondition: @unchecked Sendable, Codable, JSONEncodable {
    public var confidence: Float?
    public var contentCountRuleParams: ContentCountRuleParameters?
    public var contentCountryCodeParams: ContentCountryCodeParameters?
    public var contentCustomPropertyCountParams: ContentCustomPropertyCountParameters?
    public var contentCustomPropertyParams: ContentCustomPropertyParameters?
    public var contentFlagCountRuleParams: FlagCountRuleParameters?
    public var floodIdenticalParams: FloodIdenticalRuleParameters?
    public var floodSimilarParams: FloodSimilarRuleParameters?
    public var imageContentParams: ImageContentParameters?
    public var imageRuleParams: ImageRuleParameters?
    /// intent_rule params: policy intent topic label and the minimum final score (1-100) that fires the condition
    public var intentRuleParams: IntentRuleParameters?
    public var ipContentCountRuleParams: IPContentCountRuleParameters?
    public var ipFlagCountRuleParams: IPFlagCountRuleParameters?
    public var ocrContentParams: OCRContentParameters?
    public var textContentParams: TextContentParameters?
    public var textRuleParams: TextRuleParameters?
    public var type: String?
    public var userCreatedWithinParams: UserCreatedWithinParameters?
    public var userCustomPropertyParams: UserCustomPropertyParameters?
    public var userFlagCountRuleParams: FlagCountRuleParameters?
    public var userIdenticalContentCountParams: UserIdenticalContentCountParameters?
    public var userIdenticalImageCountParams: UserIdenticalImageCountParameters?
    public var userReactionCountParams: UserReactionCountRuleParameters?
    public var userRoleParams: UserRoleParameters?
    public var userRuleParams: UserRuleParameters?
    public var videoContentParams: VideoContentParameters?
    public var videoRuleParams: VideoRuleParameters?

    public init(
        confidence: Float? = nil,
        contentCountRuleParams: ContentCountRuleParameters? = nil,
        contentCountryCodeParams: ContentCountryCodeParameters? = nil,
        contentCustomPropertyCountParams: ContentCustomPropertyCountParameters? = nil,
        contentCustomPropertyParams: ContentCustomPropertyParameters? = nil,
        contentFlagCountRuleParams: FlagCountRuleParameters? = nil,
        floodIdenticalParams: FloodIdenticalRuleParameters? = nil,
        floodSimilarParams: FloodSimilarRuleParameters? = nil,
        imageContentParams: ImageContentParameters? = nil,
        imageRuleParams: ImageRuleParameters? = nil,
        intentRuleParams: IntentRuleParameters? = nil,
        ipContentCountRuleParams: IPContentCountRuleParameters? = nil,
        ipFlagCountRuleParams: IPFlagCountRuleParameters? = nil,
        ocrContentParams: OCRContentParameters? = nil,
        textContentParams: TextContentParameters? = nil,
        textRuleParams: TextRuleParameters? = nil,
        userCreatedWithinParams: UserCreatedWithinParameters? = nil,
        userCustomPropertyParams: UserCustomPropertyParameters? = nil,
        userFlagCountRuleParams: FlagCountRuleParameters? = nil,
        userIdenticalContentCountParams: UserIdenticalContentCountParameters? = nil,
        userIdenticalImageCountParams: UserIdenticalImageCountParameters? = nil,
        userReactionCountParams: UserReactionCountRuleParameters? = nil,
        userRoleParams: UserRoleParameters? = nil,
        userRuleParams: UserRuleParameters? = nil,
        videoContentParams: VideoContentParameters? = nil,
        videoRuleParams: VideoRuleParameters? = nil
    ) {
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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case confidence
        case contentCountRuleParams = "content_count_rule_params"
        case contentCountryCodeParams = "content_country_code_params"
        case contentCustomPropertyCountParams = "content_custom_property_count_params"
        case contentCustomPropertyParams = "content_custom_property_params"
        case contentFlagCountRuleParams = "content_flag_count_rule_params"
        case floodIdenticalParams = "flood_identical_params"
        case floodSimilarParams = "flood_similar_params"
        case imageContentParams = "image_content_params"
        case imageRuleParams = "image_rule_params"
        case intentRuleParams = "intent_rule_params"
        case ipContentCountRuleParams = "ip_content_count_rule_params"
        case ipFlagCountRuleParams = "ip_flag_count_rule_params"
        case ocrContentParams = "ocr_content_params"
        case textContentParams = "text_content_params"
        case textRuleParams = "text_rule_params"
        case type
        case userCreatedWithinParams = "user_created_within_params"
        case userCustomPropertyParams = "user_custom_property_params"
        case userFlagCountRuleParams = "user_flag_count_rule_params"
        case userIdenticalContentCountParams = "user_identical_content_count_params"
        case userIdenticalImageCountParams = "user_identical_image_count_params"
        case userReactionCountParams = "user_reaction_count_params"
        case userRoleParams = "user_role_params"
        case userRuleParams = "user_rule_params"
        case videoContentParams = "video_content_params"
        case videoRuleParams = "video_rule_params"
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
