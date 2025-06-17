import Foundation
import StreamCore

public final class ListBlockListResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var blocklists: [BlockListResponse]
    public var duration: String

    public init(blocklists: [BlockListResponse], duration: String) {
        self.blocklists = blocklists
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklists
        case duration
    }

    public static func == (lhs: ListBlockListResponse, rhs: ListBlockListResponse) -> Bool {
        lhs.blocklists == rhs.blocklists &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklists)
        hasher.combine(duration)
    }
}
