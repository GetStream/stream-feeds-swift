//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OCRContentParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var harmLabels: [String]?
    public var labelOperator: String?
    public var severity: String?

    public init(harmLabels: [String]? = nil, labelOperator: String? = nil, severity: String? = nil) {
        self.harmLabels = harmLabels
        self.labelOperator = labelOperator
        self.severity = severity
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case harmLabels = "harm_labels"
        case labelOperator = "label_operator"
        case severity
    }
}

extension OCRContentParameters: Hashable {
    public static func == (lhs: OCRContentParameters, rhs: OCRContentParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels &&
            lhs.labelOperator == rhs.labelOperator &&
            lhs.severity == rhs.severity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
        hasher.combine(labelOperator)
        hasher.combine(severity)
    }
}
