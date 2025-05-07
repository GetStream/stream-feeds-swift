import Foundation
import StreamCore

public final class StoriesConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var expirationBehaviour: String?
    public var skipWatched: Bool?

    public init(expirationBehaviour: String? = nil, skipWatched: Bool? = nil) {
        self.expirationBehaviour = expirationBehaviour
        self.skipWatched = skipWatched
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case expirationBehaviour = "expiration_behaviour"
        case skipWatched = "skip_watched"
    }

    public static func == (lhs: StoriesConfig, rhs: StoriesConfig) -> Bool {
        lhs.expirationBehaviour == rhs.expirationBehaviour &&
            lhs.skipWatched == rhs.skipWatched
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(expirationBehaviour)
        hasher.combine(skipWatched)
    }
}
