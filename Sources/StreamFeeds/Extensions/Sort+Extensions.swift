//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension Sort {
    /// Converts this sort configuration to a format suitable for API requests.
    ///
    /// - Returns: A `SortParamRequest` object containing the field and direction for the API
    func toRequest() -> SortParamRequest {
        SortParamRequest(
            direction: direction.rawValue,
            field: field.rawValue
        )
    }
}
