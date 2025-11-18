//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        let epsilon = 1e-7 // ~1cm precision
        return abs(lhs.latitude - rhs.latitude) < epsilon &&
            abs(lhs.longitude - rhs.longitude) < epsilon
    }
}
