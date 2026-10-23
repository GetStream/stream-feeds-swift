//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Configuration for rejecting an appeal
public final class RejectAppealRequestPayload: Sendable, Codable, JSONEncodable {
    /// Reason for rejecting the appeal
    public let decisionReason: String

    public init(decisionReason: String) {
        self.decisionReason = decisionReason
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.decisionReason = try container.decode(String.self, forKey: .decisionReason)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(decisionReason, forKey: .decisionReason)
    }
}

extension RejectAppealRequestPayload: Hashable {
    public static func == (lhs: RejectAppealRequestPayload, rhs: RejectAppealRequestPayload) -> Bool {
        lhs.decisionReason == rhs.decisionReason
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(decisionReason)
    }
}
