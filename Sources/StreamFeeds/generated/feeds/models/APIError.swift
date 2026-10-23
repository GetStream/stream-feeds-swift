//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class APIError: Sendable, Codable, JSONEncodable {
    /// API error code
    public let code: Int
    /// Additional error-specific information
    public let details: [Int]
    /// Request duration
    public let duration: String
    /// Additional error info
    public let exceptionFields: [String: String]?
    /// Message describing an error
    public let message: String
    /// URL with additional information
    public let moreInfo: String
    /// Response HTTP status code
    public let statusCode: Int
    /// Flag that indicates if the error is unrecoverable, requests that return unrecoverable errors should not be retried, this error only applies to the request that caused it
    public let unrecoverable: Bool?

    public init(code: Int, details: [Int], duration: String, exceptionFields: [String: String]? = nil, message: String, moreInfo: String, statusCode: Int, unrecoverable: Bool? = nil) {
        self.code = code
        self.details = details
        self.duration = duration
        self.exceptionFields = exceptionFields
        self.message = message
        self.moreInfo = moreInfo
        self.statusCode = statusCode
        self.unrecoverable = unrecoverable
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.code = try container.decode(Int.self, forKey: .code)
        self.details = try container.decode([Int].self, forKey: .details)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.exceptionFields = try container.decodeIfPresent([String: String].self, forKey: .exceptionFields)
        self.message = try container.decode(String.self, forKey: .message)
        self.moreInfo = try container.decode(String.self, forKey: .moreInfo)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.unrecoverable = try container.decodeIfPresent(Bool.self, forKey: .unrecoverable)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(code, forKey: .code)
        try container.encode(details, forKey: .details)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(exceptionFields, forKey: .exceptionFields)
        try container.encode(message, forKey: .message)
        try container.encode(moreInfo, forKey: .moreInfo)
        try container.encode(statusCode, forKey: .statusCode)
        try container.encodeIfPresent(unrecoverable, forKey: .unrecoverable)
    }
}

extension APIError: Hashable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.code == rhs.code &&
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
        hasher.combine(details)
        hasher.combine(duration)
        hasher.combine(exceptionFields)
        hasher.combine(message)
        hasher.combine(moreInfo)
        hasher.combine(statusCode)
        hasher.combine(unrecoverable)
    }
}
