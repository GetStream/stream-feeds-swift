//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var `default`: JSONDecoder { .streamCore }
}

extension JSONEncoder {
    static var `default`: JSONEncoder { .streamCore }
}
