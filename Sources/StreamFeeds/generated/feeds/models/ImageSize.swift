//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ImageSize: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum ImageSizeCrop: String, Sendable, Codable, CaseIterable {
        case bottom
        case center
        case left
        case right
        case top
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum ImageSizeResize: String, Sendable, Codable, CaseIterable {
        case clip
        case crop
        case fill
        case scale
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var crop: ImageSizeCrop?
    public var height: Int?
    public var resize: ImageSizeResize?
    public var width: Int?

    public init(crop: ImageSizeCrop? = nil, height: Int? = nil, resize: ImageSizeResize? = nil, width: Int? = nil) {
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
