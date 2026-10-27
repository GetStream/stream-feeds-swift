//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Whether poll votes are attributed to the voter.
public enum VotingVisibility: String, Sendable, Codable, CaseIterable {
    /// Votes are public and can be seen by everyone.
    case `public`
    /// Votes are anonymous and cannot be attributed to individual users.
    case anonymous
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = VotingVisibility(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
