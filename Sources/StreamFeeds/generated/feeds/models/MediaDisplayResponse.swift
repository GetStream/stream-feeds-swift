//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MediaDisplayResponseMode: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let blur = MediaDisplayResponseMode(rawValue: "blur")
    public static let blurGrayscale = MediaDisplayResponseMode(rawValue: "blur_grayscale")
    public static let normal = MediaDisplayResponseMode(rawValue: "normal")
}

/// Display policy for a review queue item's images and video
public final class MediaDisplayResponse: Sendable, Codable, JSONEncodable {
    /// Reveals must be recorded via the reveal media endpoint (blurred CSAM or gore)
    public let auditReveal: Bool
    /// Default rendering before a reveal
    public let mode: MediaDisplayResponseMode
    /// Only users with the RevealProtectedMedia permission may reveal the media (CSAM)
    public let revealRestricted: Bool

    public init(auditReveal: Bool, mode: MediaDisplayResponseMode, revealRestricted: Bool) {
        self.auditReveal = auditReveal
        self.mode = mode
        self.revealRestricted = revealRestricted
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.auditReveal = try container.decode(Bool.self, forKey: .auditReveal)
        self.mode = try container.decode(MediaDisplayResponseMode.self, forKey: .mode)
        self.revealRestricted = try container.decode(Bool.self, forKey: .revealRestricted)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(auditReveal, forKey: .auditReveal)
        try container.encode(mode, forKey: .mode)
        try container.encode(revealRestricted, forKey: .revealRestricted)
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
