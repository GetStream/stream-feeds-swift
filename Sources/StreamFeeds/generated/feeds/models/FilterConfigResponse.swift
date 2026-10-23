//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FilterConfigResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// AI image moderation labels available as filter values. Reflects the app's effective image taxonomy: custom Bodyguard taxonomy when enabled, otherwise the standard L1 label set.
    public var aiImageLabels: [String]?
    /// Labels the image OCR pipeline can flag, available as filter values on the `label` field under the ai_image category. The app's LLM labels when LLM configurability is enabled, otherwise the AI text labels. OCR and image-classification labels share the `label` field, so a name present in both matches either.
    public var aiImageOcrLabels: [String]?
    /// AI image moderation labels available as filter values, as a map of L1 label to its L2 sub-labels. Reflects the app's effective image taxonomy: custom Bodyguard taxonomy when enabled, otherwise the standard catalogue of the org's enabled image providers.
    public var aiImageTaxonomy: [String: [String]]?
    /// AI text moderation labels available as filter values
    public var aiTextLabels: [String]?
    /// Moderation config keys present in the queue, available as filter values
    public var configKeys: [String]?
    /// The moderation_payload.custom keys the app has configured as review-queue filter chips (via moderation_dashboard_preferences.filterable_custom_keys). Discovery hint for the dashboard only — the filter accepts any custom key regardless of this list.
    public var filterableCustomKeys: [String]?
    /// LLM moderation labels available as filter values
    public var llmLabels: [String]
    /// Names of the app's moderation rules, available as filter values on the `label` field when filtering rule-flagged content. Includes disabled rules, since items flagged before a rule was turned off still carry its name; excludes deleted ones. Scoped to the caller's teams on a multi-tenant app. Capped at 30 names, ordered by name, so an app above that cap is listed partially.
    public var ruleNames: [String]?

    public init(
        aiImageLabels: [String]? = nil,
        aiImageOcrLabels: [String]? = nil,
        aiImageTaxonomy: [String: [String]]? = nil,
        aiTextLabels: [String]? = nil,
        configKeys: [String]? = nil,
        filterableCustomKeys: [String]? = nil,
        llmLabels: [String],
        ruleNames: [String]? = nil
    ) {
        self.aiImageLabels = aiImageLabels
        self.aiImageOcrLabels = aiImageOcrLabels
        self.aiImageTaxonomy = aiImageTaxonomy
        self.aiTextLabels = aiTextLabels
        self.configKeys = configKeys
        self.filterableCustomKeys = filterableCustomKeys
        self.llmLabels = llmLabels
        self.ruleNames = ruleNames
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case aiImageLabels = "ai_image_labels"
        case aiImageOcrLabels = "ai_image_ocr_labels"
        case aiImageTaxonomy = "ai_image_taxonomy"
        case aiTextLabels = "ai_text_labels"
        case configKeys = "config_keys"
        case filterableCustomKeys = "filterable_custom_keys"
        case llmLabels = "llm_labels"
        case ruleNames = "rule_names"
    }
}

extension FilterConfigResponse: Hashable {
    public static func == (lhs: FilterConfigResponse, rhs: FilterConfigResponse) -> Bool {
        lhs.aiImageLabels == rhs.aiImageLabels &&
            lhs.aiImageOcrLabels == rhs.aiImageOcrLabels &&
            lhs.aiImageTaxonomy == rhs.aiImageTaxonomy &&
            lhs.aiTextLabels == rhs.aiTextLabels &&
            lhs.configKeys == rhs.configKeys &&
            lhs.filterableCustomKeys == rhs.filterableCustomKeys &&
            lhs.llmLabels == rhs.llmLabels &&
            lhs.ruleNames == rhs.ruleNames
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(aiImageLabels)
        hasher.combine(aiImageOcrLabels)
        hasher.combine(aiImageTaxonomy)
        hasher.combine(aiTextLabels)
        hasher.combine(configKeys)
        hasher.combine(filterableCustomKeys)
        hasher.combine(llmLabels)
        hasher.combine(ruleNames)
    }
}
