import Foundation
import StreamCore

public final class MuteRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var targetIds: [String]
    public var timeout: Int?

    public init(targetIds: [String], timeout: Int? = nil) {
        self.targetIds = targetIds
        self.timeout = timeout
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case targetIds = "target_ids"
        case timeout
    }

    public static func == (lhs: MuteRequest, rhs: MuteRequest) -> Bool {
        lhs.targetIds == rhs.targetIds &&
            lhs.timeout == rhs.timeout
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(targetIds)
        hasher.combine(timeout)
    }
}
