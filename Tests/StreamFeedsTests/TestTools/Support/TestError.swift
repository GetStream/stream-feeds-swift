//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

final class TestError: ClientError, @unchecked Sendable {
    override init(_ message: String = UUID().uuidString, _ file: StaticString = #fileID, _ line: UInt = #line) {
        super.init(message, file, line)
    }
}
