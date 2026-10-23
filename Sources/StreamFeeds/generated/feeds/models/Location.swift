//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Location: Sendable, Codable, JSONEncodable {
    /// Latitude coordinate
    public let lat: Double
    /// Longitude coordinate
    public let lng: Double

    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lng = try container.decode(Double.self, forKey: .lng)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(lng, forKey: .lng)
    }
}

extension Location: Hashable {
    public static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.lat == rhs.lat &&
            lhs.lng == rhs.lng
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(lat)
        hasher.combine(lng)
    }
}
