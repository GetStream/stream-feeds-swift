//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Display policy for a review queue item's images and video
public final class MediaDisplayResponse: @unchecked Sendable, Codable, JSONEncodable {
    public enum MediaDisplayResponseMode: String, Sendable, Codable, CaseIterable {
        case blur
        case blurGrayscale = "blur_grayscale"
        case normal
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

    /// Reveals must be recorded via the reveal media endpoint (blurred CSAM or gore)
    public var auditReveal: Bool
    /// Default rendering before a reveal
    public var mode: MediaDisplayResponseMode
    /// Only users with the RevealProtectedMedia permission may reveal the media (CSAM)
    public var revealRestricted: Bool

    public init(auditReveal: Bool, mode: MediaDisplayResponseMode, revealRestricted: Bool) {
        self.auditReveal = auditReveal
        self.mode = mode
        self.revealRestricted = revealRestricted
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case auditReveal = "audit_reveal"
        case mode
        case revealRestricted = "reveal_restricted"
    }
}

extension MediaDisplayResponse: Hashable {
    public static func == (lhs: MediaDisplayResponse, rhs: MediaDisplayResponse) -> Bool {
        lhs.auditReveal == rhs.auditReveal &&
            lhs.mode == rhs.mode &&
            lhs.revealRestricted == rhs.revealRestricted
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(auditReveal)
        hasher.combine(mode)
        hasher.combine(revealRestricted)
    }
}
