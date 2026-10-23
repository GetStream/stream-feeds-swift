//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageContentParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var harmLabels: [String]?
    public var labelOperator: String?
    public var minConfidence: Float?

    public init(
        harmLabels: [String]? = nil,
        labelOperator: String? = nil,
        minConfidence: Float? = nil
    ) {
        self.harmLabels = harmLabels
        self.labelOperator = labelOperator
        self.minConfidence = minConfidence
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case harmLabels = "harm_labels"
        case labelOperator = "label_operator"
        case minConfidence = "min_confidence"
    }
}

extension ImageContentParameters: Hashable {
    public static func == (lhs: ImageContentParameters, rhs: ImageContentParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.labelOperator == rhs.labelOperator &&
            lhs.minConfidence == rhs.minConfidence
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(labelOperator)
        hasher.combine(minConfidence)
    }
}
