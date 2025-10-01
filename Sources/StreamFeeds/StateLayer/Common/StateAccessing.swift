//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

/// A protocol that provides thread-safe access to state objects.
///
/// This protocol allows for safe access to state properties and methods
/// from any thread by ensuring the access happens on the main actor.
@MainActor protocol StateAccessing {
    @discardableResult func access<T>(_ actions: @MainActor (Self) -> T) -> T
}

extension StateAccessing {
    @discardableResult func access<T>(_ actions: @MainActor (Self) -> T) -> T {
        actions(self)
    }
}
