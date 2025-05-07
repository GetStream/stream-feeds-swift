import Foundation
import StreamCore

public final class ActivityAttachment: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var assetUrl: String?
    public var custom: [String: RawJSON]?
    public var imageUrl: String?
    public var liveCallCid: String?
    public var type: String
    public var url: String

    public init(assetUrl: String? = nil, custom: [String: RawJSON]? = nil, imageUrl: String? = nil, liveCallCid: String? = nil, type: String, url: String) {
        self.assetUrl = assetUrl
        self.custom = custom
        self.imageUrl = imageUrl
        self.liveCallCid = liveCallCid
        self.type = type
        self.url = url
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case assetUrl = "asset_url"
        case custom
        case imageUrl = "image_url"
        case liveCallCid = "live_call_cid"
        case type
        case url
    }

    public static func == (lhs: ActivityAttachment, rhs: ActivityAttachment) -> Bool {
        lhs.assetUrl == rhs.assetUrl &&
            lhs.custom == rhs.custom &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.liveCallCid == rhs.liveCallCid &&
            lhs.type == rhs.type &&
            lhs.url == rhs.url
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(assetUrl)
        hasher.combine(custom)
        hasher.combine(imageUrl)
        hasher.combine(liveCallCid)
        hasher.combine(type)
        hasher.combine(url)
    }
}
