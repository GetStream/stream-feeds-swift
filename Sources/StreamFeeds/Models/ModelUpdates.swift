//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ModelUpdates<Model>: Sendable where Model: Sendable {
    public let added: [Model]
    public let removedIds: [String]
    public let updated: [Model]
}
