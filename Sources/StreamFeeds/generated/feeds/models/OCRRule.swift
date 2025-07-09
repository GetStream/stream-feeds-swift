import Foundation
import StreamCore

public final class OCRRule: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum OCRRuleAction: String, Sendable, Codable, CaseIterable {
        case bounce
        case bounceFlag = "bounce_flag"
        case bounceRemove = "bounce_remove"
        case flag
        case remove
        case shadow
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var action: OCRRuleAction
    public var label: String

    public init(action: OCRRuleAction, label: String) {
        self.action = action
        self.label = label
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case label
    }

    public static func == (lhs: OCRRule, rhs: OCRRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.label == rhs.label
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(label)
    }
}
