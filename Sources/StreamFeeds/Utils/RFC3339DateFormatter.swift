//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

struct RFC3339DateFormatter: Sendable {
    private static let shared = RFC3339DateFormatter()
    
    static func string(from date: Date) -> String {
        shared.string(from: date)
    }
    
    func string(from date: Date) -> String {
        formatter.string(from: date)
    }
    
    static func date(from dateString: String) -> Date? {
        shared.date(from: dateString)
    }
    
    func date(from dateString: String) -> Date? {
        formatter.dateWithMicroseconds(from: dateString)
    }

    nonisolated(unsafe) private let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

extension ISO8601DateFormatter {
    func dateWithMicroseconds(from string: String) -> Date? {
        guard let date = date(from: string) else { return nil }
        // Manually parse microseconds and nanoseconds, because ISO8601DateFormatter is limited to ms.
        // Note that Date's timeIntervalSince1970 rounds to 0.000_000_1
        guard let index = string.lastIndex(of: ".") else { return date }
        let range = string.suffix(from: index)
            .dropFirst(4) // . and ms part
            .dropLast() // Z
        var fractionWithoutMilliseconds = String(range)
        if fractionWithoutMilliseconds.count < 3 {
            fractionWithoutMilliseconds = fractionWithoutMilliseconds.padding(toLength: 3, withPad: "0", startingAt: 0)
        }
        guard let microseconds = TimeInterval("0.000".appending(fractionWithoutMilliseconds)) else { return date }
        return Date(timeIntervalSince1970: date.timeIntervalSince1970 + microseconds)
    }
}
