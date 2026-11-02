//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Location: @unchecked Sendable, Codable, JSONEncodable {
    /// Latitude coordinate
    public var lat: Float
    /// Longitude coordinate
    public var lng: Float

    public init(lat: Float, lng: Float) {
        self.lat = lat
        self.lng = lng
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case lat
        case lng
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
