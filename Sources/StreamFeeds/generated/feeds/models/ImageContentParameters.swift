//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageContentParameters: Sendable, Codable, JSONEncodable {
    public let harmLabels: [String]?

    public init(harmLabels: [String]? = nil) {
        self.harmLabels = harmLabels
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.harmLabels = try container.decodeIfPresent([String].self, forKey: .harmLabels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
    }
}

extension ImageContentParameters: Hashable {
    public static func == (lhs: ImageContentParameters, rhs: ImageContentParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
    }
}
