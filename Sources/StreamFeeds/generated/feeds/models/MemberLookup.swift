import Foundation
import StreamCore

public final class MemberLookup: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var limit: Int

    public init(limit: Int) {
        self.limit = limit
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case limit = "Limit"
    }

    public static func == (lhs: MemberLookup, rhs: MemberLookup) -> Bool {
        lhs.limit == rhs.limit
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(limit)
    }
}
