import Foundation
import StreamCore

public final class StreamData: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var id: String

    public init(id: String) {
        self.id = id
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
    }

    public static func == (lhs: StreamData, rhs: StreamData) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
