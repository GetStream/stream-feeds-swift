//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollOptionResponseData {
    static func dummy(
        custom: [String: RawJSON] = [:],
        id: String = "option-123",
        text: String = "Test option",
        textI18n: [String: String]? = nil
    ) -> PollOptionResponseData {
        PollOptionResponseData(
            custom: custom,
            id: id,
            text: text,
            textI18n: textI18n
        )
    }
}
