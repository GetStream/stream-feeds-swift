import Foundation
import StreamCore

public final class SharedLocationsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activeLiveLocations: [SharedLocationResponseData]
    public var duration: String

    public init(activeLiveLocations: [SharedLocationResponseData], duration: String) {
        self.activeLiveLocations = activeLiveLocations
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activeLiveLocations = "active_live_locations"
        case duration
    }

    public static func == (lhs: SharedLocationsResponse, rhs: SharedLocationsResponse) -> Bool {
        lhs.activeLiveLocations == rhs.activeLiveLocations &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activeLiveLocations)
        hasher.combine(duration)
    }
}
