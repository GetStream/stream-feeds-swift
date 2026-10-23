//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserIdenticalImageCountParameters: Sendable, Codable, JSONEncodable {
    public let match: String?
    public let similarityDistance: Int?
    public let threshold: Int?
    public let timeWindow: String?

    public init(match: String? = nil, similarityDistance: Int? = nil, threshold: Int? = nil, timeWindow: String? = nil) {
        self.match = match
        self.similarityDistance = similarityDistance
        self.threshold = threshold
        self.timeWindow = timeWindow
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.match = try container.decodeIfPresent(String.self, forKey: .match)
        self.similarityDistance = try container.decodeIfPresent(Int.self, forKey: .similarityDistance)
        self.threshold = try container.decodeIfPresent(Int.self, forKey: .threshold)
        self.timeWindow = try container.decodeIfPresent(String.self, forKey: .timeWindow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(match, forKey: .match)
        try container.encodeIfPresent(similarityDistance, forKey: .similarityDistance)
        try container.encodeIfPresent(threshold, forKey: .threshold)
        try container.encodeIfPresent(timeWindow, forKey: .timeWindow)
    }
}

extension UserIdenticalImageCountParameters: Hashable {
    public static func == (lhs: UserIdenticalImageCountParameters, rhs: UserIdenticalImageCountParameters) -> Bool {
        lhs.match == rhs.match &&
            lhs.similarityDistance == rhs.similarityDistance &&
            lhs.threshold == rhs.threshold &&
            lhs.timeWindow == rhs.timeWindow
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(match)
        hasher.combine(similarityDistance)
        hasher.combine(threshold)
        hasher.combine(timeWindow)
    }
}
