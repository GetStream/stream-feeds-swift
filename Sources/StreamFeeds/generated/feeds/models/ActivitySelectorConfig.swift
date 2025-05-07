import Foundation
import StreamCore

public final class ActivitySelectorConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var cutoffTime: Date
    public var minPopularity: Int?
    public var tagFilterType: String?
    public var tags: [String]?
    public var type: String

    public init(cutoffTime: Date, minPopularity: Int? = nil, tagFilterType: String? = nil, tags: [String]? = nil, type: String) {
        self.cutoffTime = cutoffTime
        self.minPopularity = minPopularity
        self.tagFilterType = tagFilterType
        self.tags = tags
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case cutoffTime = "cutoff_time"
        case minPopularity = "min_popularity"
        case tagFilterType = "tag_filter_type"
        case tags
        case type
    }

    public static func == (lhs: ActivitySelectorConfig, rhs: ActivitySelectorConfig) -> Bool {
        lhs.cutoffTime == rhs.cutoffTime &&
            lhs.minPopularity == rhs.minPopularity &&
            lhs.tagFilterType == rhs.tagFilterType &&
            lhs.tags == rhs.tags &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(cutoffTime)
        hasher.combine(minPopularity)
        hasher.combine(tagFilterType)
        hasher.combine(tags)
        hasher.combine(type)
    }
}
