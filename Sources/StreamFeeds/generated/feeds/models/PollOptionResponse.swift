//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollOptionResponse: Sendable, Decodable {
    /// Duration of the request in milliseconds
    public let duration: String
    public let pollOption: PollOptionResponseData

    public init(duration: String, pollOption: PollOptionResponseData) {
        self.duration = duration
        self.pollOption = pollOption
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.pollOption = try container.decode(PollOptionResponseData.self, forKey: .pollOption)
    }
}

extension PollOptionResponse: Hashable {
    public static func == (lhs: PollOptionResponse, rhs: PollOptionResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.pollOption == rhs.pollOption
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(pollOption)
    }
}
