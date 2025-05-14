import Foundation
import StreamCore

public final class AggregationConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var format: String?

    public init(format: String? = nil) {
        self.format = format
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case format
    }

    public static func == (lhs: AggregationConfig, rhs: AggregationConfig) -> Bool {
        lhs.format == rhs.format
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(format)
    }
}
