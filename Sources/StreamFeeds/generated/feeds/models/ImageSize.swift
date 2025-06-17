import Foundation
import StreamCore

public final class ImageSize: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var crop: String?
    public var height: Int?
    public var resize: String?
    public var width: Int?

    public init(crop: String? = nil, height: Int? = nil, resize: String? = nil, width: Int? = nil) {
        self.crop = crop
        self.height = height
        self.resize = resize
        self.width = width
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case crop
        case height
        case resize
        case width
    }

    public static func == (lhs: ImageSize, rhs: ImageSize) -> Bool {
        lhs.crop == rhs.crop &&
            lhs.height == rhs.height &&
            lhs.resize == rhs.resize &&
            lhs.width == rhs.width
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(crop)
        hasher.combine(height)
        hasher.combine(resize)
        hasher.combine(width)
    }
}
