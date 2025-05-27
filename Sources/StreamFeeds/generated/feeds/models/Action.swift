import Foundation
import StreamCore

public final class Action: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var name: String
    public var style: String?
    public var text: String
    public var type: String
    public var value: String?

    public init(name: String, style: String? = nil, text: String, type: String, value: String? = nil) {
        self.name = name
        self.style = style
        self.text = text
        self.type = type
        self.value = value
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case style
        case text
        case type
        case value
    }

    public static func == (lhs: Action, rhs: Action) -> Bool {
        lhs.name == rhs.name &&
            lhs.style == rhs.style &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(style)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(value)
    }
}
