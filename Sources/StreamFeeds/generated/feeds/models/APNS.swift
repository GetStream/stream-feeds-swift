//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class APNS: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var body: String
    public var contentAvailable: Int?
    public var data: [String: RawJSON]?
    public var mutableContent: Int?
    public var sound: String?
    public var title: String

    public init(body: String, contentAvailable: Int? = nil, data: [String: RawJSON]? = nil, mutableContent: Int? = nil, sound: String? = nil, title: String) {
        self.body = body
        self.contentAvailable = contentAvailable
        self.data = data
        self.mutableContent = mutableContent
        self.sound = sound
        self.title = title
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case body
        case contentAvailable = "content-available"
        case data
        case mutableContent = "mutable-content"
        case sound
        case title
    }

    public static func == (lhs: APNS, rhs: APNS) -> Bool {
        lhs.body == rhs.body &&
            lhs.contentAvailable == rhs.contentAvailable &&
            lhs.data == rhs.data &&
            lhs.mutableContent == rhs.mutableContent &&
            lhs.sound == rhs.sound &&
            lhs.title == rhs.title
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(body)
        hasher.combine(contentAvailable)
        hasher.combine(data)
        hasher.combine(mutableContent)
        hasher.combine(sound)
        hasher.combine(title)
    }
}
