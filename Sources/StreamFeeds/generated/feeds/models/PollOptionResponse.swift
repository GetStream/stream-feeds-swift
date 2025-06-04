import Foundation
import StreamCore

public final class PollOptionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var pollOption: PollOptionResponseData

    public init(duration: String, pollOption: PollOptionResponseData) {
        self.duration = duration
        self.pollOption = pollOption
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case pollOption = "poll_option"
    }

    public static func == (lhs: PollOptionResponse, rhs: PollOptionResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.pollOption == rhs.pollOption
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(pollOption)
    }
}
