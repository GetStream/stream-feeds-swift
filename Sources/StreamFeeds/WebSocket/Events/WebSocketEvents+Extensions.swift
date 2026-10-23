//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension ConnectedEvent {
    public func healthcheck() -> HealthCheckInfo? {
        HealthCheckInfo(connectionId: connectionId)
    }
}

extension HealthCheckEvent: HealthCheck {
    public func healthcheck() -> HealthCheckInfo? {
        HealthCheckInfo(connectionId: connectionId)
    }
}
