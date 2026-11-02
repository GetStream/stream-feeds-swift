//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The privacy settings of the user.
public final class PrivacySettingsResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// The settings for the read receipt events.
    public var readReceipts: ReadReceiptsResponse?

    public init(readReceipts: ReadReceiptsResponse? = nil) {
        self.readReceipts = readReceipts
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case readReceipts = "read_receipts"
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
