//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderCondition: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var confidence: Float?
    public var contentCountRuleParams: ContentCountRuleParameters?
    public var imageContentParams: ImageContentParameters?
    public var imageRuleParams: ImageRuleParameters?
    public var textContentParams: TextContentParameters?
    public var textRuleParams: TextRuleParameters?
    public var type: String
    public var userCreatedWithinParams: UserCreatedWithinParameters?
    public var userRuleParams: UserRuleParameters?
    public var videoContentParams: VideoContentParameters?
    public var videoRuleParams: VideoRuleParameters?

    public init(confidence: Float? = nil, contentCountRuleParams: ContentCountRuleParameters? = nil, imageContentParams: ImageContentParameters? = nil, imageRuleParams: ImageRuleParameters? = nil, textContentParams: TextContentParameters? = nil, textRuleParams: TextRuleParameters? = nil, type: String, userCreatedWithinParams: UserCreatedWithinParameters? = nil, userRuleParams: UserRuleParameters? = nil, videoContentParams: VideoContentParameters? = nil, videoRuleParams: VideoRuleParameters? = nil) {
        self.confidence = confidence
        self.contentCountRuleParams = contentCountRuleParams
        self.imageContentParams = imageContentParams
        self.imageRuleParams = imageRuleParams
        self.textContentParams = textContentParams
        self.textRuleParams = textRuleParams
        self.type = type
        self.userCreatedWithinParams = userCreatedWithinParams
        self.userRuleParams = userRuleParams
        self.videoContentParams = videoContentParams
        self.videoRuleParams = videoRuleParams
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case confidence
        case contentCountRuleParams = "content_count_rule_params"
        case imageContentParams = "image_content_params"
        case imageRuleParams = "image_rule_params"
        case textContentParams = "text_content_params"
        case textRuleParams = "text_rule_params"
        case type
        case userCreatedWithinParams = "user_created_within_params"
        case userRuleParams = "user_rule_params"
        case videoContentParams = "video_content_params"
        case videoRuleParams = "video_rule_params"
    }

    public static func == (lhs: RuleBuilderCondition, rhs: RuleBuilderCondition) -> Bool {
        lhs.confidence == rhs.confidence &&
            lhs.contentCountRuleParams == rhs.contentCountRuleParams &&
            lhs.imageContentParams == rhs.imageContentParams &&
            lhs.imageRuleParams == rhs.imageRuleParams &&
            lhs.textContentParams == rhs.textContentParams &&
            lhs.textRuleParams == rhs.textRuleParams &&
            lhs.type == rhs.type &&
            lhs.userCreatedWithinParams == rhs.userCreatedWithinParams &&
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
        hasher.combine(userRuleParams)
        hasher.combine(videoContentParams)
        hasher.combine(videoRuleParams)
    }
}
