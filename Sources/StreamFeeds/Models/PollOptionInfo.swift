//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollOptionInfo: Identifiable, Sendable {
    public let custom: [String: RawJSON]
    public let id: String
    public let text: String
    
    init(from response: PollOptionResponseData) {
        self.custom = response.custom
        self.id = response.id
        self.text = response.text
    }
} 
