//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

struct QueryConfiguration<F, S> where F: Filter, S: SortField {
    let filter: F?
    let sort: [Sort<S>]?
}
