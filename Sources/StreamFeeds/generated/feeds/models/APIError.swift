//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class APIError: @unchecked Sendable, Codable, JSONEncodable {
    /// API error code
    public var code: Int
    /// Milliseconds until the user's slow mode cool down period ends. Only set on code 60 (cool down) errors
    public var cooldownRemainingMs: Int?
    /// Additional error-specific information
    public var details: [Int]
    /// Request duration
    public var duration: String
    /// Additional error info
    public var exceptionFields: [String: String]?
    /// Message describing an error
    public var message: String
    /// URL with additional information
    public var moreInfo: String
    /// Response HTTP status code
    public var statusCode: Int
    /// Flag that indicates if the error is unrecoverable, requests that return unrecoverable errors should not be retried, this error only applies to the request that caused it
    public var unrecoverable: Bool?

    public init(
        code: Int,
        cooldownRemainingMs: Int? = nil,
        details: [Int],
        duration: String,
        exceptionFields: [String: String]? = nil,
        message: String,
        moreInfo: String,
        statusCode: Int,
        unrecoverable: Bool? = nil
    ) {
        self.code = code
        self.cooldownRemainingMs = cooldownRemainingMs
        self.details = details
        self.duration = duration
        self.exceptionFields = exceptionFields
        self.message = message
        self.moreInfo = moreInfo
        self.statusCode = statusCode
        self.unrecoverable = unrecoverable
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case code
        case cooldownRemainingMs = "cooldown_remaining_ms"
        case details
        case duration
        case exceptionFields = "exception_fields"
        case message
        case moreInfo = "more_info"
        case statusCode = "StatusCode"
        case unrecoverable
    }
}

extension APIError: Hashable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.code == rhs.code &&
            lhs.cooldownRemainingMs == rhs.cooldownRemainingMs &&
            lhs.details == rhs.details &&
            lhs.duration == rhs.duration &&
            lhs.exceptionFields == rhs.exceptionFields &&
            lhs.message == rhs.message &&
            lhs.moreInfo == rhs.moreInfo &&
            lhs.statusCode == rhs.statusCode &&
            lhs.unrecoverable == rhs.unrecoverable
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
        hasher.combine(cooldownRemainingMs)
        hasher.combine(details)
        hasher.combine(duration)
        hasher.combine(exceptionFields)
        hasher.combine(message)
        hasher.combine(moreInfo)
        hasher.combine(statusCode)
        hasher.combine(unrecoverable)
    }
}
