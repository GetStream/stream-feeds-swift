//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Enrichment status of a collection entry.
public final class CollectionStatus: RawRepresentable, Decodable, CustomStringConvertible, Hashable, Sendable {
    public let rawValue: String

    public var description: String { rawValue }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let notfound = CollectionStatus(rawValue: "notfound")
    public static let ok = CollectionStatus(rawValue: "ok")
}
