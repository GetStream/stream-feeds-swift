//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public enum FilterOperator: String, Sendable {
    /// Matches values that are equal to a specified value or matches all of the values in an array.
    case equal = "$eq"

    /// Matches values that are greater than a specified value.
    case greater = "$gt"

    /// Matches values that are greater than a specified value.
    case greaterOrEqual = "$gte"

    /// Matches values that are less than a specified value.
    case less = "$lt"

    /// Matches values that are less than or equal to a specified value.
    case lessOrEqual = "$lte"

    /// Matches any of the values specified in an array.
    case `in` = "$in"

    /// Matches values by performing text search with the specified value.
    case query = "$q"

    /// Matches values with the specified text.
    case autocomplete = "$autocomplete"

    /// Matches values that exist/don't exist based on the specified boolean value.
    case exists = "$exists"

    /// Matches all the values specified in an array.
    case and = "$and"

    /// Matches at least one of the values specified in an array.
    case or = "$or"

    /// Matches if the key array contains the given value.
    case contains = "$contains"
}

extension FilterOperator {
    var isGroup: Bool {
        switch self {
        case .and, .or: return true
        default: return false
        }
    }
}
