import Foundation
import StreamCore

public final class SubmitActionResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var item: ReviewQueueItemResponse?

    public init(duration: String, item: ReviewQueueItemResponse? = nil) {
        self.duration = duration
        self.item = item
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case item
    }

    public static func == (lhs: SubmitActionResponse, rhs: SubmitActionResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.item == rhs.item
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(item)
    }
}
