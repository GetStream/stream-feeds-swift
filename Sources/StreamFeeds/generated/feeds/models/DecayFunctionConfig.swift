//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DecayFunctionConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var base: String?
    public var decay: String?
    public var direction: String?
    public var offset: String?
    public var origin: String?
    public var scale: String?

    public init(base: String? = nil, decay: String? = nil, direction: String? = nil, offset: String? = nil, origin: String? = nil, scale: String? = nil) {
        self.base = base
        self.decay = decay
        self.direction = direction
        self.offset = offset
        self.origin = origin
        self.scale = scale
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case base
        case decay
        case direction
        case offset
        case origin
        case scale
    }

    public static func == (lhs: DecayFunctionConfig, rhs: DecayFunctionConfig) -> Bool {
        lhs.base == rhs.base &&
            lhs.decay == rhs.decay &&
            lhs.direction == rhs.direction &&
            lhs.offset == rhs.offset &&
            lhs.origin == rhs.origin &&
            lhs.scale == rhs.scale
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(base)
        hasher.combine(decay)
        hasher.combine(direction)
        hasher.combine(offset)
        hasher.combine(origin)
        hasher.combine(scale)
    }
}
