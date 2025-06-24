import Foundation
import StreamCore

public final class ModerationPayload: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var custom: [String: RawJSON]?
    public var images: [String]?
    public var texts: [String]?
    public var videos: [String]?

    public init(custom: [String: RawJSON]? = nil, images: [String]? = nil, texts: [String]? = nil, videos: [String]? = nil) {
        self.custom = custom
        self.images = images
        self.texts = texts
        self.videos = videos
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case custom
        case images
        case texts
        case videos
    }

    public static func == (lhs: ModerationPayload, rhs: ModerationPayload) -> Bool {
        lhs.custom == rhs.custom &&
            lhs.images == rhs.images &&
            lhs.texts == rhs.texts &&
            lhs.videos == rhs.videos
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(custom)
        hasher.combine(images)
        hasher.combine(texts)
        hasher.combine(videos)
    }
}
