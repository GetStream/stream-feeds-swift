//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class OwnCapabilitiesBatchResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var capabilities: [String: [FeedOwnCapability]]
    public var duration: String

    public init(capabilities: [String: [FeedOwnCapability]], duration: String) {
        self.capabilities = capabilities
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case capabilities
        case duration
    }

    public static func == (lhs: OwnCapabilitiesBatchResponse, rhs: OwnCapabilitiesBatchResponse) -> Bool {
        lhs.capabilities == rhs.capabilities &&
        lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(capabilities)
        hasher.combine(duration)
    }
}
