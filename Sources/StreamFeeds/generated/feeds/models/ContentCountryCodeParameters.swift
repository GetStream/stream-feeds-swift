//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ContentCountryCodeParameters: @unchecked Sendable, Codable, JSONEncodable {
    public var `operator`: String?
    public var countryCodes: [String]?

    public init(operator: String? = nil, countryCodes: [String]? = nil) {
        self.operator = `operator`
        self.countryCodes = countryCodes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case `operator`
        case countryCodes = "country_codes"
    }
}

extension ContentCountryCodeParameters: Hashable {
    public static func == (lhs: ContentCountryCodeParameters, rhs: ContentCountryCodeParameters) -> Bool {
        lhs.operator == rhs.operator &&
            lhs.countryCodes == rhs.countryCodes
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(`operator`)
        hasher.combine(countryCodes)
    }
}
