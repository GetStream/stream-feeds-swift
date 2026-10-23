//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VideoContentParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var harmLabels: [String]?
    public var labelOperator: String?

    public init(harmLabels: [String]? = nil, labelOperator: String? = nil) {
        self.harmLabels = harmLabels
        self.labelOperator = labelOperator
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case harmLabels = "harm_labels"
        case labelOperator = "label_operator"
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
