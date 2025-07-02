//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

struct JSONEventDecoder: AnyEventDecoder {
    func decode(from data: Data) throws -> Event {
        let event = try StreamJSONDecoder.default.decode(FeedsEvent.self, from: data)
        return event.rawValue
    }
}
