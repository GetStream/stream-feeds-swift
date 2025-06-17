import Foundation
import StreamCore

public final class GetBlockedUsersResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var blocks: [BlockedUserResponse]
    public var duration: String

    public init(blocks: [BlockedUserResponse], duration: String) {
        self.blocks = blocks
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocks
        case duration
    }

    public static func == (lhs: GetBlockedUsersResponse, rhs: GetBlockedUsersResponse) -> Bool {
        lhs.blocks == rhs.blocks &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocks)
        hasher.combine(duration)
    }
}
