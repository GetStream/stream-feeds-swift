import Foundation
import StreamCore

public final class BanResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String

    public init(duration: String) {
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
    }

    public static func == (lhs: BanResponse, rhs: BanResponse) -> Bool {
        lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
    }
}
