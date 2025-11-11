//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

extension Dictionary {
    func contains(_ key: Key?) -> Bool {
        guard let key else { return false }
        return self[key] != nil
    }
}
