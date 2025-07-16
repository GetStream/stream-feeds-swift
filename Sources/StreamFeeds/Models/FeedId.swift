//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// A unique identifier for a feed in the Stream Feeds system.
///
/// A `FeedId` consists of two components:
/// - `group`: The feed group identifier (e.g., "user", "timeline", "notification")
/// - `id`: The specific feed identifier within that group
///
/// The complete feed identifier is represented as a colon-separated string: `"group:id"`
/// For example: `"user:john"`, `"timeline:flat"`, `"notification:aggregated"`
///
/// This type is thread-safe and can be used across different execution contexts.
public struct FeedId: Equatable, Sendable {
    /// The feed group identifier that categorizes the type of feed.
    ///
    /// Common group IDs include:
    /// - `"user"`: User-specific feeds
    /// - `"timeline"`: Timeline feeds
    /// - `"notification"`: Notification feeds
    /// - `"aggregated"`: Aggregated feeds
    public let group: String
    
    /// The specific feed identifier within the group.
    ///
    /// This is typically a user ID, feed name, or other unique identifier
    /// that distinguishes this feed from others in the same group.
    public let id: String
    
    /// The complete feed identifier as a colon-separated string.
    ///
    /// This is the canonical string representation of the feed ID,
    /// formatted as `"group:id"`. This value is used for API requests
    /// and serialization.
    public let rawValue: String
    
    /// Creates a new feed identifier with the specified group and feed IDs.
    ///
    /// - Parameters:
    ///   - group: The feed group identifier (e.g., "user", "timeline")
    ///   - id: The specific feed identifier within the group
    ///
    /// - Example:
    ///   ```swift
    ///   let userFeed = FeedId(group: "user", id: "john")
    ///   // Creates "user:john"
    ///   ```
    public init(group: String, id: String) {
        self.group = group
        self.id = id
        rawValue = "\(group):\(id)"
    }
    
    /// Creates a feed identifier from a raw string value.
    ///
    /// The string should be in the format `"group:id"`. If the string
    /// doesn't contain a colon separator, the entire string will be used
    /// as the `id` and `group` will be empty.
    ///
    /// - Parameter rawValue: The raw string representation of the feed ID
    ///
    /// - Example:
    ///   ```swift
    ///   let feed = FeedId(rawValue: "user:john")
    ///   // Creates FeedId with group: "user", id: "john"
    ///   ```
    public init(rawValue: String) {
        self.rawValue = rawValue
        let components = rawValue.split(separator: ":")
        group = String(components.first ?? "")
        id = String(components.last ?? "")
    }
}

extension FeedId: CustomStringConvertible, Hashable {
    /// A string representation of the feed identifier.
    ///
    /// Returns the same value as `rawValue`.
    public var description: String {
        rawValue
    }
    
    /// Compares two feed identifiers for equality.
    ///
    /// Two `FeedId` instances are considered equal if their `rawValue` properties are equal.
    public static func == (lhs: FeedId, rhs: FeedId) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    /// Generates a hash value for the feed identifier.
    ///
    /// The hash is based on the `rawValue` property.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
