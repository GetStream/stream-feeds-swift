//
//  AddedAsset.swift
//  DemoApp
//
//  Created by Martin Mitrevski on 30.5.25.
//

import Foundation
import UIKit
import StreamCore

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
