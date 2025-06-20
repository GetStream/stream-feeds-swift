import Foundation
import StreamCore

public final class ActivitySelectorConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var cutoffTime: Date
    public var filter: [String: RawJSON]?
    public var minPopularity: Int?
    public var sort: [SortParam]?
    public var type: String?

    public init(cutoffTime: Date, filter: [String: RawJSON]? = nil, minPopularity: Int? = nil, sort: [SortParam]? = nil) {
        self.cutoffTime = cutoffTime
        self.filter = filter
        self.minPopularity = minPopularity
        self.sort = sort
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case cutoffTime = "cutoff_time"
        case filter
        case minPopularity = "min_popularity"
        case sort
        case type
    }

    public static func == (lhs: ActivitySelectorConfig, rhs: ActivitySelectorConfig) -> Bool {
        lhs.cutoffTime == rhs.cutoffTime &&
            lhs.filter == rhs.filter &&
            lhs.minPopularity == rhs.minPopularity &&
            lhs.sort == rhs.sort &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(cutoffTime)
        hasher.combine(filter)
        hasher.combine(minPopularity)
        hasher.combine(sort)
        hasher.combine(type)
    }
}

//TODO: move this.
public struct SortParam: @unchecked Sendable, Codable, JSONEncodable, Hashable {}
