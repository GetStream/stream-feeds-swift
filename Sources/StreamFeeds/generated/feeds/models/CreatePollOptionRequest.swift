import Foundation
import StreamCore

public final class CreatePollOptionRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var position: Int?
    public var text: String

    public init(custom: [String: RawJSON]? = nil, position: Int? = nil, text: String) {
        self.custom = custom
        self.position = position
        self.text = text
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom = "Custom"
        case position
        case text
    }

    public static func == (lhs: CreatePollOptionRequest, rhs: CreatePollOptionRequest) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.position == rhs.position &&
            lhs.text == rhs.text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(position)
        hasher.combine(text)
    }
}
