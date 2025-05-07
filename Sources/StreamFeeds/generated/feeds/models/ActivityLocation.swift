import Foundation
import StreamCore

public final class ActivityLocation: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var lat: Float
    public var lng: Float

    public init(lat: Float, lng: Float) {
        self.lat = lat
        self.lng = lng
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case lat
        case lng
    }

    public static func == (lhs: ActivityLocation, rhs: ActivityLocation) -> Bool {
        lhs.lat == rhs.lat &&
            lhs.lng == rhs.lng
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(lat)
        hasher.combine(lng)
    }
}
