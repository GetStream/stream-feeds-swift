//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ConfigOverrides: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum ConfigOverridesBlocklistBehavior: String, Sendable, Codable, CaseIterable {
        case block
        case flag
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

    public var blocklist: String?
    public var blocklistBehavior: ConfigOverridesBlocklistBehavior?
    public var commands: [String]
    public var countMessages: Bool?
    public var grants: [String: [String]]
    public var maxMessageLength: Int?
    public var quotes: Bool?
    public var reactions: Bool?
    public var replies: Bool?
    public var sharedLocations: Bool?
    public var typingEvents: Bool?
    public var uploads: Bool?
    public var urlEnrichment: Bool?
    public var userMessageReminders: Bool?

    public init(blocklist: String? = nil, blocklistBehavior: ConfigOverridesBlocklistBehavior? = nil, commands: [String], countMessages: Bool? = nil, grants: [String: [String]], maxMessageLength: Int? = nil, quotes: Bool? = nil, reactions: Bool? = nil, replies: Bool? = nil, sharedLocations: Bool? = nil, typingEvents: Bool? = nil, uploads: Bool? = nil, urlEnrichment: Bool? = nil, userMessageReminders: Bool? = nil) {
        self.blocklist = blocklist
        self.blocklistBehavior = blocklistBehavior
        self.commands = commands
        self.countMessages = countMessages
        self.grants = grants
        self.maxMessageLength = maxMessageLength
        self.quotes = quotes
        self.reactions = reactions
        self.replies = replies
        self.sharedLocations = sharedLocations
        self.typingEvents = typingEvents
        self.uploads = uploads
        self.urlEnrichment = urlEnrichment
        self.userMessageReminders = userMessageReminders
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blocklist
        case blocklistBehavior = "blocklist_behavior"
        case commands
        case countMessages = "count_messages"
        case grants
        case maxMessageLength = "max_message_length"
        case quotes
        case reactions
        case replies
        case sharedLocations = "shared_locations"
        case typingEvents = "typing_events"
        case uploads
        case urlEnrichment = "url_enrichment"
        case userMessageReminders = "user_message_reminders"
    }

    public static func == (lhs: ConfigOverrides, rhs: ConfigOverrides) -> Bool {
        lhs.blocklist == rhs.blocklist &&
            lhs.blocklistBehavior == rhs.blocklistBehavior &&
            lhs.commands == rhs.commands &&
            lhs.countMessages == rhs.countMessages &&
            lhs.grants == rhs.grants &&
            lhs.maxMessageLength == rhs.maxMessageLength &&
            lhs.quotes == rhs.quotes &&
            lhs.reactions == rhs.reactions &&
            lhs.replies == rhs.replies &&
            lhs.sharedLocations == rhs.sharedLocations &&
            lhs.typingEvents == rhs.typingEvents &&
            lhs.uploads == rhs.uploads &&
            lhs.urlEnrichment == rhs.urlEnrichment &&
            lhs.userMessageReminders == rhs.userMessageReminders
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blocklist)
        hasher.combine(blocklistBehavior)
        hasher.combine(commands)
        hasher.combine(countMessages)
        hasher.combine(grants)
        hasher.combine(maxMessageLength)
        hasher.combine(quotes)
        hasher.combine(reactions)
        hasher.combine(replies)
        hasher.combine(sharedLocations)
        hasher.combine(typingEvents)
        hasher.combine(uploads)
        hasher.combine(urlEnrichment)
        hasher.combine(userMessageReminders)
    }
}
