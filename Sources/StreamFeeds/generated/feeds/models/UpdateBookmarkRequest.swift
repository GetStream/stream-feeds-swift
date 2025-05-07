import Foundation
import StreamCore

public final class UpdateBookmarkRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?

    public init(custom: [String: RawJSON]? = nil) {
        self.custom = custom
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
    }

    public static func == (lhs: UpdateBookmarkRequest, rhs: UpdateBookmarkRequest) -> Bool {
        lhs.custom == rhs.custom
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
    }
}
