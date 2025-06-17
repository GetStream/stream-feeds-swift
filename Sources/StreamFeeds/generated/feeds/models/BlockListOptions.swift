import Foundation
import StreamCore

public final class BlockListOptions: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum string: String, Sendable, Codable, CaseIterable {
        case block
        case flag
        case shadowBlock = "shadow_block"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue)
            {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var behavior: String
    public var blocklist: String

    public init(behavior: String, blocklist: String) {
        self.behavior = behavior
        self.blocklist = blocklist
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case behavior
        case blocklist
    }

    public static func == (lhs: BlockListOptions, rhs: BlockListOptions) -> Bool {
        lhs.behavior == rhs.behavior &&
            lhs.blocklist == rhs.blocklist
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(behavior)
        hasher.combine(blocklist)
    }
}
