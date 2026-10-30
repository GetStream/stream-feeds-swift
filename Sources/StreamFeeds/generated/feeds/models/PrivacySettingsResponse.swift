//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The privacy settings of the user.
public final class PrivacySettingsResponse: Sendable, Codable, JSONEncodable {
    /// The settings for the read receipt events.
    public let readReceipts: ReadReceiptsResponse?

    public init(readReceipts: ReadReceiptsResponse? = nil) {
        self.readReceipts = readReceipts
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.readReceipts = try container.decodeIfPresent(ReadReceiptsResponse.self, forKey: .readReceipts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(readReceipts, forKey: .readReceipts)
    }
}

extension PrivacySettingsResponse: Hashable {
    public static func == (lhs: PrivacySettingsResponse, rhs: PrivacySettingsResponse) -> Bool {
        lhs.readReceipts == rhs.readReceipts
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(readReceipts)
    }
}
