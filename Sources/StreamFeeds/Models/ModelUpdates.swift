//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ModelUpdates<Model>: Sendable where Model: Sendable {
    public internal(set) var added: [Model]
    public internal(set) var removedIds: Set<String>
    public internal(set) var updated: [Model]
}

extension ModelUpdates {
    init(added: [Model] = [], removedIds: [String] = [], updated: [Model] = []) {
        self.init(added: added, removedIds: Set(removedIds), updated: updated)
    }
}
