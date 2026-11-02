//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public var duration: String
    public var poll: PollResponseData

    public init(duration: String, poll: PollResponseData) {
        self.duration = duration
        self.poll = poll
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case poll
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
