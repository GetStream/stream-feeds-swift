//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollResponse: Sendable, Decodable {
    public let poll: PollResponseData

    public init(poll: PollResponseData) {
        self.poll = poll
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.poll = try container.decode(PollResponseData.self, forKey: .poll)
    }
}

extension PollResponse: Hashable {
    public static func == (lhs: PollResponse, rhs: PollResponse) -> Bool {
        lhs.poll == rhs.poll
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(poll)
    }
}
