//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ContentCountryCodeParameters: Sendable, Codable, JSONEncodable {
    public let `operator`: String?
    public let countryCodes: [String]?

    public init(operator: String? = nil, countryCodes: [String]? = nil) {
        self.operator = `operator`
        self.countryCodes = countryCodes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.operator = try container.decodeIfPresent(String.self, forKey: .operator)
        self.countryCodes = try container.decodeIfPresent([String].self, forKey: .countryCodes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(`operator`, forKey: .operator)
        try container.encodeIfPresent(countryCodes, forKey: .countryCodes)
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
