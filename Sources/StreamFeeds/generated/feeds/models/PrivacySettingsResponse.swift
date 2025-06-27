import Foundation
import StreamCore

public final class PrivacySettingsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var readReceipts: ReadReceiptsResponse?

    public init(readReceipts: ReadReceiptsResponse? = nil) {
        self.readReceipts = readReceipts
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case readReceipts = "read_receipts"
    }

    public static func == (lhs: PrivacySettingsResponse, rhs: PrivacySettingsResponse) -> Bool {
        lhs.readReceipts == rhs.readReceipts
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(readReceipts)
    }
}
