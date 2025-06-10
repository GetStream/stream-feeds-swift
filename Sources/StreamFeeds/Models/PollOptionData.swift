//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollOptionData: Identifiable, Sendable {
    public let custom: [String: RawJSON]
    public let id: String
    public let text: String
}

// MARK: - Model Conversions

extension PollOptionResponseData {
    func toModel() -> PollOptionData {
        PollOptionData(
            custom: custom,
            id: id,
            text: text
        )
    }
}
