//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FilterConfigResponse: Sendable, Codable, JSONEncodable {
    /// AI image moderation labels available as filter values. Reflects the app's effective image taxonomy: custom Bodyguard taxonomy when enabled, otherwise the standard L1 label set.
    public let aiImageLabels: [String]?
    /// Labels the image OCR pipeline can flag, available as filter values on the `label` field under the ai_image category. The app's LLM labels when LLM configurability is enabled, otherwise the AI text labels. OCR and image-classification labels share the `label` field, so a name present in both matches either.
    public let aiImageOcrLabels: [String]?
    /// AI image moderation labels available as filter values, as a map of L1 label to its L2 sub-labels. Reflects the app's effective image taxonomy: custom Bodyguard taxonomy when enabled, otherwise the standard catalogue of the org's enabled image providers.
    public let aiImageTaxonomy: [String: [String]]?
    /// AI text moderation labels available as filter values
    public let aiTextLabels: [String]?
    /// Moderation config keys present in the queue, available as filter values
    public let configKeys: [String]?
    /// The moderation_payload.custom keys the app has configured as review-queue filter chips (via moderation_dashboard_preferences.filterable_custom_keys). Discovery hint for the dashboard only — the filter accepts any custom key regardless of this list.
    public let filterableCustomKeys: [String]?
    /// LLM moderation labels available as filter values
    public let llmLabels: [String]
    /// Names of the app's moderation rules, available as filter values on the `label` field when filtering rule-flagged content. Includes disabled rules, since items flagged before a rule was turned off still carry its name; excludes deleted ones. Scoped to the caller's teams on a multi-tenant app. Capped at 30 names, ordered by name, so an app above that cap is listed partially.
    public let ruleNames: [String]?

    public init(aiImageLabels: [String]? = nil, aiImageOcrLabels: [String]? = nil, aiImageTaxonomy: [String: [String]]? = nil, aiTextLabels: [String]? = nil, configKeys: [String]? = nil, filterableCustomKeys: [String]? = nil, llmLabels: [String], ruleNames: [String]? = nil) {
        self.aiImageLabels = aiImageLabels
        self.aiImageOcrLabels = aiImageOcrLabels
        self.aiImageTaxonomy = aiImageTaxonomy
        self.aiTextLabels = aiTextLabels
        self.configKeys = configKeys
        self.filterableCustomKeys = filterableCustomKeys
        self.llmLabels = llmLabels
        self.ruleNames = ruleNames
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.aiImageLabels = try container.decodeIfPresent([String].self, forKey: .aiImageLabels)
        self.aiImageOcrLabels = try container.decodeIfPresent([String].self, forKey: .aiImageOcrLabels)
        self.aiImageTaxonomy = try container.decodeIfPresent([String: [String]].self, forKey: .aiImageTaxonomy)
        self.aiTextLabels = try container.decodeIfPresent([String].self, forKey: .aiTextLabels)
        self.configKeys = try container.decodeIfPresent([String].self, forKey: .configKeys)
        self.filterableCustomKeys = try container.decodeIfPresent([String].self, forKey: .filterableCustomKeys)
        self.llmLabels = try container.decode([String].self, forKey: .llmLabels)
        self.ruleNames = try container.decodeIfPresent([String].self, forKey: .ruleNames)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(aiImageLabels, forKey: .aiImageLabels)
        try container.encodeIfPresent(aiImageOcrLabels, forKey: .aiImageOcrLabels)
        try container.encodeIfPresent(aiImageTaxonomy, forKey: .aiImageTaxonomy)
        try container.encodeIfPresent(aiTextLabels, forKey: .aiTextLabels)
        try container.encodeIfPresent(configKeys, forKey: .configKeys)
        try container.encodeIfPresent(filterableCustomKeys, forKey: .filterableCustomKeys)
        try container.encode(llmLabels, forKey: .llmLabels)
        try container.encodeIfPresent(ruleNames, forKey: .ruleNames)
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
