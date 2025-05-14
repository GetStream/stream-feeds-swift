import Foundation
import StreamCore

public final class RankingConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var decayFactor: Float?
    public var defaults: [String: RawJSON]
    public var functions: [String: DecayFunctionConfig]
    public var recencyWeight: Float?
    public var score: String
    public var type: String?

    public init(decayFactor: Float? = nil, defaults: [String: RawJSON], functions: [String: DecayFunctionConfig], recencyWeight: Float? = nil, score: String) {
        self.decayFactor = decayFactor
        self.defaults = defaults
        self.functions = functions
        self.recencyWeight = recencyWeight
        self.score = score
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case decayFactor = "decay_factor"
        case defaults
        case functions
        case recencyWeight = "recency_weight"
        case score
        case type
    }

    public static func == (lhs: RankingConfig, rhs: RankingConfig) -> Bool {
        lhs.decayFactor == rhs.decayFactor &&
            lhs.defaults == rhs.defaults &&
            lhs.functions == rhs.functions &&
            lhs.recencyWeight == rhs.recencyWeight &&
            lhs.score == rhs.score &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(decayFactor)
        hasher.combine(defaults)
        hasher.combine(functions)
        hasher.combine(recencyWeight)
        hasher.combine(score)
        hasher.combine(type)
    }
}
