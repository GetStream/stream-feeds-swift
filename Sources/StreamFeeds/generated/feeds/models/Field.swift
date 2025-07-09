//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Field: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var short: Bool
    public var title: String
    public var value: String

    public init(short: Bool, title: String, value: String) {
        self.short = short
        self.title = title
        self.value = value
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case short
        case title
        case value
    }

    public static func == (lhs: Field, rhs: Field) -> Bool {
        lhs.short == rhs.short &&
            lhs.title == rhs.title &&
            lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(short)
        hasher.combine(title)
        hasher.combine(value)
    }
}
