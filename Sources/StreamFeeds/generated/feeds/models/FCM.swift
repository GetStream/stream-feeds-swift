import Foundation
import StreamCore

public final class FCM: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var data: [String: RawJSON]?

    public init(data: [String: RawJSON]? = nil) {
        self.data = data
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case data
    }

    public static func == (lhs: FCM, rhs: FCM) -> Bool {
        lhs.data == rhs.data
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
}
