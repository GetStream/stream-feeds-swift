//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VideoContentParameters: Sendable, Codable, JSONEncodable {
    public let harmLabels: [String]?
    public let labelOperator: String?

    public init(harmLabels: [String]? = nil, labelOperator: String? = nil) {
        self.harmLabels = harmLabels
        self.labelOperator = labelOperator
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.harmLabels = try container.decodeIfPresent([String].self, forKey: .harmLabels)
        self.labelOperator = try container.decodeIfPresent(String.self, forKey: .labelOperator)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(harmLabels, forKey: .harmLabels)
        try container.encodeIfPresent(labelOperator, forKey: .labelOperator)
    }
}

extension VideoContentParameters: Hashable {
    public static func == (lhs: VideoContentParameters, rhs: VideoContentParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.labelOperator == rhs.labelOperator
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(labelOperator)
    }
}
