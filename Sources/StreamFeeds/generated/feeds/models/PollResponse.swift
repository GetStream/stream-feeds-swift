//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollResponse: Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public let duration: String
    public let poll: PollResponseData

    public init(duration: String, poll: PollResponseData) {
        self.duration = duration
        self.poll = poll
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.poll = try container.decode(PollResponseData.self, forKey: .poll)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(poll, forKey: .poll)
    }
}

extension PollResponse: Hashable {
    public static func == (lhs: PollResponse, rhs: PollResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.poll == rhs.poll
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(poll)
    }
}
