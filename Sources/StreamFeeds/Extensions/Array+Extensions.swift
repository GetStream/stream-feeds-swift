//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

extension Array {
    mutating func insert(byId element: Element) where Element: Identifiable {
        if let index = firstIndex(where: { $0.id == element.id }) {
            replaceSubrange(index...index, with: CollectionOfOne(element))
        } else {
            insert(element, at: startIndex)
        }
    }
    
    mutating func remove(byId element: Element) where Element: Identifiable {
        guard let index = firstIndex(where: { $0.id == element.id }) else { return }
        remove(at: index)
    }
}
