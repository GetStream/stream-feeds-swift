//
//  JsonEventDecoder.swift
//  StreamFeeds
//
//  Created by Martin Mitrevski on 5.5.25.
//

import Foundation
import StreamCore

struct JsonEventDecoder: AnyEventDecoder {
    func decode(from data: Data) throws -> Event {
        let event = try StreamJSONDecoder.default.decode(FeedsEvent.self, from: data)
        return event.rawValue
    }
}
