//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

extension Date {
    static func fixed(offset: Int = 0) -> Date {
        Date(timeIntervalSince1970: 1_753_773_025 + TimeInterval(offset))
    }
}
