import Foundation
import StreamCore

public final class GetApplicationResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var app: AppResponseFields
    public var duration: String

    public init(app: AppResponseFields, duration: String) {
        self.app = app
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case app
        case duration
    }

    public static func == (lhs: GetApplicationResponse, rhs: GetApplicationResponse) -> Bool {
        lhs.app == rhs.app &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(app)
        hasher.combine(duration)
    }
}
