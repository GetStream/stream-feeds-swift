//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// Erase type for structs which recursively contain themselves.
///
/// Example:
/// ```swift
/// struct ActivityInfo {
///   let parent: ActivityInfo?
/// }
/// ```
/// Can be written as:
/// ```swift
/// struct ActivityInfo {
///   let parent: ActivityInfo? { _parent.value as? ActivityInfo }
///   let _parent: BoxedAny?
/// }
/// ```
struct BoxedAny {
    init?(_ value: (any Sendable)?) {
        guard value != nil else { return nil }
        self.value = value
    }

    let value: any Sendable
}
