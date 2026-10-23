//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VideoContentParameters: Sendable, Encodable, JSONEncodable {
    public let harmLabels: [String]?

    public init(harmLabels: [String]? = nil) {
        self.harmLabels = harmLabels
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
    }
}

extension VideoContentParameters: Hashable {
    public static func == (lhs: VideoContentParameters, rhs: VideoContentParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
    }
}
