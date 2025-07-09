import Foundation
//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore

public final class PrivacySettings: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var readReceipts: ReadReceipts?

    public init(readReceipts: ReadReceipts? = nil) {
        self.readReceipts = readReceipts
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case readReceipts = "read_receipts"
    }

    public static func == (lhs: PrivacySettings, rhs: PrivacySettings) -> Bool {
        lhs.readReceipts == rhs.readReceipts
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(readReceipts)
    }
}
