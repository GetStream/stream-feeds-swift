//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageContentParameters: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var harmLabels: [String]?

    public init(harmLabels: [String]? = nil) {
        self.harmLabels = harmLabels
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case harmLabels = "harm_labels"
    }

    public static func == (lhs: ImageContentParameters, rhs: ImageContentParameters) -> Bool {
        lhs.harmLabels == rhs.harmLabels
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(harmLabels)
    }
}
