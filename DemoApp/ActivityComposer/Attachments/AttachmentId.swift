//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// An object that uniquely identifies a message attachment.
public struct AttachmentId: Hashable {
    public let fid: String

    public let activityId: String

    /// The position of the attachment within the message. The first attachment index is 0, then 1, etc.
    public let index: Int

    public init(
        fid: String,
        activityId: String,
        index: Int
    ) {
        self.fid = fid
        self.activityId = activityId
        self.index = index
    }
}

// MARK: - RawRepresentable

extension AttachmentId: RawRepresentable {
    static let separator: String = "/"

    public init?(rawValue: String) {
        let components = rawValue.components(separatedBy: Self.separator)
        guard
            components.count == 3,
            let index = Int(components[2])
        else { return nil }

        let fid = String(components[0])
        
        self.init(
            fid: fid,
            activityId: components[1],
            index: index
        )
    }

    public var rawValue: String {
        [fid, activityId, String(index)].joined(separator: Self.separator)
    }
}
