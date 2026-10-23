//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// One recurring quiet window, expressed in local wall-clock time in the schedule's timezone.
public final class QuietHoursRuleInput: Sendable, Codable, JSONEncodable {
    /// The days of the week the window opens on, any of mon, tue, wed, thu, fri, sat, sun, each at most once. A window belongs to the day it opens: ["fri"] with 22:00 to 07:00 is quiet from Friday 22:00 until Saturday 07:00, and not on Saturday night. Empty or omitted means every day.
    public let days: [String]?
    /// When the window closes, as HH:MM local wall-clock time between 00:00 and 24:00. The end is exclusive: a window ending at 07:00 is already over at 07:00. An end earlier than start wraps past midnight into the next day (start 22:00, end 07:00). 24:00 means the end of the day, so start 00:00 with end 24:00 covers the whole day.
    public let end: String
    /// When the window opens, as HH:MM local wall-clock time between 00:00 and 23:59. Must differ from end.
    public let start: String

    public init(days: [String]? = nil, end: String, start: String) {
        self.days = days
        self.end = end
        self.start = start
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.days = try container.decodeIfPresent([String].self, forKey: .days)
        self.end = try container.decode(String.self, forKey: .end)
        self.start = try container.decode(String.self, forKey: .start)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(days, forKey: .days)
        try container.encode(end, forKey: .end)
        try container.encode(start, forKey: .start)
    }
}

extension QuietHoursRuleInput: Hashable {
    public static func == (lhs: QuietHoursRuleInput, rhs: QuietHoursRuleInput) -> Bool {
        lhs.days == rhs.days &&
            lhs.end == rhs.end &&
            lhs.start == rhs.start
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(days)
        hasher.combine(end)
        hasher.combine(start)
    }
}
