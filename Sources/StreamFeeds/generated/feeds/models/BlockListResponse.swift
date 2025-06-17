import Foundation
import StreamCore

public final class BlockListResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date?
    public var id: String?
    public var name: String
    public var team: String?
    public var type: String
    public var updatedAt: Date?
    public var words: [String]

    public init(createdAt: Date? = nil, id: String? = nil, name: String, team: String? = nil, type: String, updatedAt: Date? = nil, words: [String]) {
        self.createdAt = createdAt
        self.id = id
        self.name = name
        self.team = team
        self.type = type
        self.updatedAt = updatedAt
        self.words = words
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case id
        case name
        case team
        case type
        case updatedAt = "updated_at"
        case words
    }

    public static func == (lhs: BlockListResponse, rhs: BlockListResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.team == rhs.team &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.words == rhs.words
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(team)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(words)
    }
}
