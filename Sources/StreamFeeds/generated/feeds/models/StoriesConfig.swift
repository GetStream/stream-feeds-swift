import Foundation
import StreamCore

public final class StoriesConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum StoriesVisibility: String, Sendable, Codable, CaseIterable {
        case hideForEveryone = "hide_for_everyone"
        case visibleForAuthor = "visible_for_author"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue)
            {
                self = value
            } else {
                self = .unknown
            }
        }
    }

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
