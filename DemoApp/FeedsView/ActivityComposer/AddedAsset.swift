//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
import UIKit

public struct AddedAsset: Identifiable, Equatable {
    public static func == (lhs: AddedAsset, rhs: AddedAsset) -> Bool {
        lhs.id == rhs.id
    }
    
    public let image: UIImage
    public let id: String
    public let url: URL
    public let type: AssetType
    public var extraData: [String: RawJSON] = [:]

    public init(
        image: UIImage,
        id: String,
        url: URL,
        type: AssetType,
        extraData: [String: RawJSON] = [:]
    ) {
        self.image = image
        self.id = id
        self.url = url
        self.type = type
        self.extraData = extraData
    }
}
