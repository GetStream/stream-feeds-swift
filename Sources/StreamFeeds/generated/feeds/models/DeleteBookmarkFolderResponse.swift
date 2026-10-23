//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class DeleteBookmarkFolderResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String

    public init(duration: String) {
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
    }
}

extension DeleteBookmarkFolderResponse: Hashable {
    public static func == (lhs: DeleteBookmarkFolderResponse, rhs: DeleteBookmarkFolderResponse) -> Bool {
        lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
    }
}
