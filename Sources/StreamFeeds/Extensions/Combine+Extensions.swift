//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation

extension Publisher where Self.Failure == Never {
    func asyncSink(receiveValue: @escaping @Sendable (Self.Output) async -> Void) -> AnyCancellable where Self.Output: Sendable {
        sink { value in
            Task {
                await receiveValue(value)
            }
        }
    }
}
