//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The privacy settings of the user.
public final class PrivacySettingsResponse: Sendable, Codable, JSONEncodable {
    /// The settings for the delivery receipt events.
    public let deliveryReceipts: DeliveryReceiptsResponse?
    /// The settings for the read receipt events.
    public let readReceipts: ReadReceiptsResponse?
    /// The settings for typing indicator events.
    public let typingIndicators: TypingIndicatorsResponse?

    public init(deliveryReceipts: DeliveryReceiptsResponse? = nil, readReceipts: ReadReceiptsResponse? = nil, typingIndicators: TypingIndicatorsResponse? = nil) {
        self.deliveryReceipts = deliveryReceipts
        self.readReceipts = readReceipts
        self.typingIndicators = typingIndicators
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.deliveryReceipts = try container.decodeIfPresent(DeliveryReceiptsResponse.self, forKey: .deliveryReceipts)
        self.readReceipts = try container.decodeIfPresent(ReadReceiptsResponse.self, forKey: .readReceipts)
        self.typingIndicators = try container.decodeIfPresent(TypingIndicatorsResponse.self, forKey: .typingIndicators)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(deliveryReceipts, forKey: .deliveryReceipts)
        try container.encodeIfPresent(readReceipts, forKey: .readReceipts)
        try container.encodeIfPresent(typingIndicators, forKey: .typingIndicators)
    }
}

extension PrivacySettingsResponse: Hashable {
    public static func == (lhs: PrivacySettingsResponse, rhs: PrivacySettingsResponse) -> Bool {
        lhs.deliveryReceipts == rhs.deliveryReceipts &&
            lhs.readReceipts == rhs.readReceipts &&
            lhs.typingIndicators == rhs.typingIndicators
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(deliveryReceipts)
        hasher.combine(readReceipts)
        hasher.combine(typingIndicators)
    }
}
