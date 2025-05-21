import Foundation
import StreamCore

public final class ActivityAttachment: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var assetURL: String?
    public var custom: [String: RawJSON]?
    public var imageURL: String?
    public var liveCallCID: String?
    public var type: String?
    public var uRL: String?

    public init(assetURL: String? = nil, custom: [String: RawJSON]? = nil, imageURL: String? = nil, liveCallCID: String? = nil, uRL: String? = nil) {
        self.assetURL = assetURL
        self.custom = custom
        self.imageURL = imageURL
        self.liveCallCID = liveCallCID
        self.uRL = uRL
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case assetURL = "AssetURL"
        case custom = "Custom"
        case imageURL = "ImageURL"
        case liveCallCID = "LiveCallCID"
        case type = "Type"
        case uRL = "URL"
    }

    public static func == (lhs: ActivityAttachment, rhs: ActivityAttachment) -> Bool {
        lhs.assetURL == rhs.assetURL &&
            lhs.custom == rhs.custom &&
            lhs.imageURL == rhs.imageURL &&
            lhs.liveCallCID == rhs.liveCallCID &&
            lhs.type == rhs.type &&
            lhs.uRL == rhs.uRL
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(assetURL)
        hasher.combine(custom)
        hasher.combine(imageURL)
        hasher.combine(liveCallCID)
        hasher.combine(type)
        hasher.combine(uRL)
    }
}
